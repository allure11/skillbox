#!/usr/bin/env bash
#
# install.sh — Skillbox 按需安装脚本（通用 AI 技能库）
#
# 用法：
#   ./install.sh list                    列出仓库中所有可安装的 skill
#   ./install.sh <skill名> [skill名...]   安装指定 skill（可一次装多个）
#   ./install.sh --link <skill名>        以软链方式安装（git pull 后自动同步更新）
#   ./install.sh -f <skill名>            强制覆盖已存在的同名 skill
#   ./install.sh --target <目录> <skill名>  安装到指定目录（覆盖自动检测）
#   ./install.sh                         交互式选择安装
#
# 安装目标（自动检测，按优先级）：
#   1. $SKILLS_HOME 环境变量显式指定
#   2. 已存在的平台技能目录：~/.claude/skills > ~/.workbuddy/skills > ~/.codebuddy/skills
#   3. 都未存在时默认 ~/.claude/skills（Claude Agent Skills 开源规范路径）
#
set -euo pipefail

# ---------- 定位仓库根目录（脚本可从任意位置调用） ----------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"
PLUGINS_DIR="$REPO_ROOT/plugins"

# ---------- 检测目标技能目录 ----------
detect_skills_home() {
  if [[ -n "${SKILLS_HOME:-}" ]]; then
    echo "$SKILLS_HOME"; return
  fi
  local d
  for d in "$HOME/.claude/skills" "$HOME/.workbuddy/skills" "$HOME/.codebuddy/skills"; do
    [[ -d "$d" ]] && { echo "$d"; return; }
  done
  echo "$HOME/.claude/skills"
}
SKILLS_HOME="$(detect_skills_home)"

# ---------- 颜色（非 TTY 时自动禁用） ----------
if [[ -t 1 ]]; then
  C_GREEN=$'\033[32m'; C_YELLOW=$'\033[33m'; C_CYAN=$'\033[36m'; C_RED=$'\033[31m'; C_BOLD=$'\033[1m'; C_RESET=$'\033[0m'
else
  C_GREEN=""; C_YELLOW=""; C_CYAN=""; C_RED=""; C_BOLD=""; C_RESET=""
fi
ok()   { echo "${C_GREEN}✔${C_RESET} $1"; }
warn() { echo "${C_YELLOW}⚠${C_RESET} $1"; }
info() { echo "${C_CYAN}→${C_RESET} $1"; }
err()  { echo "${C_RED}✘${C_RESET} $1" >&2; }

# ---------- 列出所有可用 skill ----------
list_skills() {
  local dir name
  local -a names=()
  for dir in "$PLUGINS_DIR"/*/; do
    [[ -d "$dir" ]] || continue
    name="$(basename "$dir")"
    [[ -f "$dir/SKILL.md" ]] && names+=("$name")
  done
  if [[ ${#names[@]} -eq 0 ]]; then
    warn "仓库中没有任何可安装的 skill（plugins/ 下为空）"
    return 1
  fi
  echo "${C_BOLD}可用 skills（${#names[@]} 个）：${C_RESET}"
  local i=1
  for name in "${names[@]}"; do
    local desc=""
    # 尝试从 SKILL.md frontmatter 提取 description
    desc="$(awk '/^description:/{sub(/^description:[[:space:]]*/,""); print; exit}' "$PLUGINS_DIR/$name/SKILL.md" 2>/dev/null || true)"
    printf '  %2d) %-28s %s\n' "$i" "$name" "$desc"
    i=$((i+1))
  done
}

# ---------- 校验 skill 名是否合法（防路径注入：只接受目录名） ----------
is_valid_skill() {
  local name="$1"
  [[ -z "$name" ]] && return 1
  [[ "$name" == *"/"* || "$name" == *".."* || "$name" == "." || "$name" == *"\\"* ]] && return 1
  [[ -d "$PLUGINS_DIR/$name" && -f "$PLUGINS_DIR/$name/SKILL.md" ]]
}

# ---------- 安装单个 skill ----------
install_one() {
  local name="$1" link_mode="$2" force="$3"
  local src="$PLUGINS_DIR/$name"
  local dest="$SKILLS_HOME/$name"

  if [[ -e "$dest" ]]; then
    if [[ "$force" == "1" ]]; then
      rm -rf "$dest"
    elif [[ -t 0 ]]; then
      read -r -p "  ⚠ $dest 已存在，覆盖？[y/N] " ans || ans="n"
      [[ "${ans:-n}" =~ ^[Yy]$ ]] || { warn "跳过 $name"; return 0; }
      rm -rf "$dest"
    else
      warn "$name 已存在，非交互模式跳过（用 -f 强制覆盖）"
      return 0
    fi
  fi

  mkdir -p "$SKILLS_HOME"
  if [[ "$link_mode" == "1" ]]; then
    ln -s "$src" "$dest"
    ok "$name 已软链安装 → ${dest}（git pull 后自动同步）"
  else
    cp -R "$src" "$dest"
    ok "$name 已复制安装 → $dest"
  fi
}

# ---------- 主逻辑 ----------
LINK_MODE=0; FORCE=0
ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --link) LINK_MODE=1; shift ;;
    -f|--force) FORCE=1; shift ;;
    --target) SKILLS_HOME="$2"; shift 2 ;;
    -h|--help) head -12 "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) ARGS+=("$1"); shift ;;
  esac
done

# 无参数 → 交互式选择
interactive_install() {
  info "仓库根目录：$REPO_ROOT"
  info "安装目标：$SKILLS_HOME"
  list_skills
  echo
  read -r -p "输入要安装的 skill 编号（多个用逗号分隔，如 1,3）：" sel
  [[ -z "$sel" ]] && { warn "未选择，退出"; return 0; }
  local -a ALL=() name
  for dir in "$PLUGINS_DIR"/*/; do
    [[ -d "$dir" && -f "$dir/SKILL.md" ]] && ALL+=("$(basename "$dir")")
  done
  IFS=',' read -ra IDX <<< "$sel"
  local i idx nm
  for idx in "${IDX[@]}"; do
    i="$(echo "$idx" | tr -d ' ')"
    [[ "$i" =~ ^[0-9]+$ ]] || { err "无效编号：$i"; continue; }
    nm="${ALL[$((i-1))]:-}"
    if [[ -n "$nm" ]]; then
      install_one "$nm" "$LINK_MODE" "$FORCE"
    else
      err "编号 $i 无效"
    fi
  done
}

if [[ ${#ARGS[@]} -eq 0 ]]; then
  interactive_install
  exit 0
fi

# 第一个参数为 list
if [[ "${ARGS[0]}" == "list" ]]; then
  list_skills
  exit 0
fi

# 按名安装
info "安装目标：$SKILLS_HOME"
for name in "${ARGS[@]}"; do
  if is_valid_skill "$name"; then
    install_one "$name" "$LINK_MODE" "$FORCE"
  else
    err "无效的 skill 名：${name}（可用 ./install.sh list 查看）"
    exit 1
  fi
done
