#!/usr/bin/env bash
#
# add-skill.sh — 把新 skill 发布进本仓库（自动生成全套插件清单）
#
# 用法：
#   ./add-skill.sh <源skill目录> ["描述文字(可选)"]
#
# 示例：
#   ./add-skill.sh ~/.claude/skills/my-new-skill
#   ./add-skill.sh ~/.claude/skills/my-new-skill "我的新技能：做某某事"
#
# 作用：
#   1. 校验源目录包含 SKILL.md
#   2. 复制到 plugins/<技能名>/skills/<技能名>/（标准插件布局）
#   3. 生成 plugins/<技能名>/.zcode-plugin/plugin.json（ZCode 优先）
#      与 plugins/<技能名>/.claude-plugin/plugin.json（Claude Code 兼容）
#   4. 同步更新三份市场清单：marketplace.json（根）
#      + .claude-plugin/marketplace.json（ZCode / Claude Code 探测点）
#      + .codebuddy-plugin/marketplace.json（WorkBuddy / CodeBuddy）
#   5. 提示下一步 git 提交流程
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"
PLUGINS_DIR="$REPO_ROOT/plugins"
MARKETPLACE="$REPO_ROOT/marketplace.json"

if [[ -t 1 ]]; then
  C_GREEN=$'\033[32m'; C_YELLOW=$'\033[33m'; C_CYAN=$'\033[36m'; C_RED=$'\033[31m'; C_BOLD=$'\033[1m'; C_RESET=$'\033[0m'
else
  C_GREEN=""; C_YELLOW=""; C_CYAN=""; C_RED=""; C_BOLD=""; C_RESET=""
fi
ok()   { echo "${C_GREEN}✔${C_RESET} $1"; }
warn() { echo "${C_YELLOW}⚠${C_RESET} $1"; }
info() { echo "${C_CYAN}→${C_RESET} $1"; }
err()  { echo "${C_RED}✘${C_RESET} $1" >&2; }

[[ $# -ge 1 ]] || { echo "用法: ./add-skill.sh <源skill目录> [\"描述\"]"; exit 1; }

SRC="${1%/}"
DESC="${2:-}"

# ---------- 校验 ----------
[[ -f "$SRC/SKILL.md" ]] || { err "源目录不存在 SKILL.md：$SRC"; exit 1; }

NAME="$(basename "$SRC")"
[[ "$NAME" =~ ^[a-z0-9][a-z0-9._-]*$ ]] || {
  err "skill 目录名不合法（须小写字母/数字开头，可含 . _ -）：$NAME"
  err "请先把源目录重命名，如：mv $SRC \$(dirname $SRC)/my-skill"
  exit 1
}

# 描述为空时从 SKILL.md frontmatter 提取
if [[ -z "$DESC" ]]; then
  DESC="$(awk '/^description:/{sub(/^description:[[:space:]]*/,""); print; exit}' "$SRC/SKILL.md" 2>/dev/null || true)"
fi
[[ -n "$DESC" ]] || DESC="（无描述，请用 add-skill.sh <目录> \"描述\" 补充）"

# 版本号：优先从 SKILL.md 读取，否则默认 1.0.0
VER="$(awk '/^version:/{sub(/^version:[[:space:]]*/,""); print; exit}' "$SRC/SKILL.md" 2>/dev/null || true)"
[[ -n "$VER" ]] || VER="1.0.0"

# ---------- 复制进仓库（标准插件布局） ----------
PLUGIN_DIR="$PLUGINS_DIR/$NAME"
SKILL_DIR="$PLUGIN_DIR/skills/$NAME"
rm -rf "$PLUGIN_DIR"
mkdir -p "$SKILL_DIR"
cp -R "$SRC/." "$SKILL_DIR/"
ok "已复制 → plugins/$NAME/skills/$NAME/"

# ---------- 生成 plugin.json（ZCode 优先 + Claude Code 兼容） ----------
MANIFEST="$PLUGIN_DIR/.zcode-plugin/plugin.json"
mkdir -p "$PLUGIN_DIR/.zcode-plugin" "$PLUGIN_DIR/.claude-plugin"
cat > "$MANIFEST" <<JSON
{
  "name": "$NAME",
  "version": "$VER",
  "description": $(printf '%s' "$DESC" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read(), ensure_ascii=False))' 2>/dev/null || printf '"%s"' "${DESC//\"/\\\"}"),
  "author": {
    "name": "ironman"
  }
}
JSON
cp "$MANIFEST" "$PLUGIN_DIR/.claude-plugin/plugin.json"
ok "已生成 plugin.json（.zcode-plugin/ + .claude-plugin/）"

# ---------- 同步三份市场清单 ----------
if ! command -v python3 >/dev/null 2>&1; then
  warn "未找到 python3，跳过市场清单更新（请手动编辑 marketplace.json）"
else
  python3 -c '
import json, os, sys

name, desc, ver = sys.argv[1], sys.argv[2], sys.argv[3]
root = sys.argv[4]
src = "./plugins/" + name

def load(path, fallback):
    if os.path.exists(path):
        with open(path, encoding="utf-8") as f:
            return json.load(f)
    return fallback

def save(path, data):
    os.makedirs(os.path.dirname(path) or ".", exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        f.write("\n")

entry_full = {"name": name, "source": src, "description": desc, "version": ver}
entry_min  = {"name": name, "source": src, "description": desc, "version": ver}

# 1) 根 marketplace.json（ZCode / Claude Code / VS Code 通用探测点）
p = os.path.join(root, "marketplace.json")
data = load(p, {"name": "skillbox", "description": "个人 AI 技能库", "owner": {"name": "ironman"}, "plugins": []})
data["plugins"] = [x for x in data.get("plugins", []) if x.get("name") != name] + [entry_full]
save(p, data)

# 2) .claude-plugin/marketplace.json（ZCode 优先探测路径）
save(os.path.join(root, ".claude-plugin", "marketplace.json"), data)

# 3) .codebuddy-plugin/marketplace.json（WorkBuddy / CodeBuddy）
p3 = os.path.join(root, ".codebuddy-plugin", "marketplace.json")
d3 = load(p3, {"name": "workbuddy-skills", "description": "个人 Skills 仓库", "owner": {"name": "ironman"}, "plugins": []})
d3["plugins"] = [x for x in d3.get("plugins", []) if x.get("name") != name] + [entry_min]
save(p3, d3)

print("marketplace updated:", name)
' "$NAME" "$DESC" "$VER" "$REPO_ROOT"
  ok "三份市场清单已更新（根 / .claude-plugin / .codebuddy-plugin）"
fi

# ---------- 下一步指引 ----------
echo
info "发布完成。下一步提交推送："
echo "  git add plugins/$NAME marketplace.json .claude-plugin/marketplace.json .codebuddy-plugin/marketplace.json"
echo "  git commit -m \"feat(skill): add $NAME\""
echo "  git push"
