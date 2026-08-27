#!/usr/bin/env bash
#
# add-skill.sh — 把新 skill 发布进本仓库
#
# 用法：
#   ./add-skill.sh <源skill目录> ["描述文字(可选)"]
#
# 示例：
#   ./add-skill.sh ~/.workbuddy/skills/my-new-skill
#   ./add-skill.sh ~/.workbuddy/skills/my-new-skill "我的新技能：做某某事"
#
# 作用：
#   1. 校验源目录包含 SKILL.md
#   2. 复制到 plugins/<skill名>/
#   3. 自动更新 .codebuddy-plugin/marketplace.json（同名则更新，否则新增）
#   4. 提示下一步 git 提交流程
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"
PLUGINS_DIR="$REPO_ROOT/plugins"
MARKETPLACE="$REPO_ROOT/.codebuddy-plugin/marketplace.json"

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
[[ "$NAME" =~ ^[a-zA-Z0-9][a-zA-Z0-9._-]*$ ]] || {
  err "skill 目录名不合法（仅允许字母/数字/._-开头为字母数字）：$NAME"
  err "请先把源目录重命名为合法名，如：mv $SRC \$(dirname $SRC)/my-skill"
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

# ---------- 复制进仓库 ----------
rm -rf "$PLUGINS_DIR/$NAME"
mkdir -p "$PLUGINS_DIR"
cp -R "$SRC" "$PLUGINS_DIR/$NAME"
ok "已复制 → plugins/$NAME/"

# ---------- 更新 marketplace.json ----------
if ! command -v python3 >/dev/null 2>&1; then
  warn "未找到 python3，跳过 marketplace.json 更新（可手动编辑）"
else
  python3 -c '
import json, sys
name, desc, ver = sys.argv[1], sys.argv[2], sys.argv[3]
path = "'"$MARKETPLACE"'"
with open(path, encoding="utf-8") as f:
    data = json.load(f)
entry = {"name": name, "description": desc, "version": ver, "source": "./plugins/" + name}
plugins = data.setdefault("plugins", [])
for i, p in enumerate(plugins):
    if p.get("name") == name:
        plugins[i] = entry
        break
else:
    plugins.append(entry)
with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)
    f.write("\n")
print("updated:", name)
' "$NAME" "$DESC" "$VER"
  ok "marketplace.json 已更新"
fi

# ---------- 下一步指引 ----------
echo
info "发布完成。下一步提交推送："
echo "  git add plugins/$NAME .codebuddy-plugin/marketplace.json"
echo "  git commit -m \"feat(skill): add $NAME\""
echo "  git push"
