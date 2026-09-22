# Skillbox — 通用 AI 技能库

个人 AI 技能（Agent Skills）集合仓库。**一个仓库管理所有技能，按需安装**——不用把几十个技能全装进环境，用到哪个装哪个。

技能遵循 **Claude Agent Skills 开源规范**（`SKILL.md` + frontmatter），凡是兼容该规范的工具均可使用：

- **Claude Code**（`~/.claude/skills/`）
- **CodeBuddy** / **WorkBuddy**（`~/.workbuddy/skills/` 等）
- **Cursor** 及其它支持 Skills 规范的 AI 工具

当前包含：

| Skill | 说明 | 版本 |
|---|---|---|
| [java-alibaba-dev-standard](plugins/java-alibaba-dev-standard/) | 阿里《Java 开发手册（嵩山版）》强制编码规范，308 条规约（强制 181 / 推荐 91 / 参考 36），覆盖命名、集合、并发、异常日志、单测、安全、MySQL、工程结构、设计 | 1.0.0 |
| [vue-style-guide](plugins/vue-style-guide/) | Vue 官方风格指南，26 条规则（A Essential 5 / B Strongly Recommended 15 / C Recommended 4 / D Use with Caution 2），覆盖组件命名、props/events 通信、模板指令、样式作用域、SFC 结构顺序 | 1.0.0 |
| [apple-hig-ui-standard](plugins/apple-hig-ui-standard/) | Apple《人机界面指南》(HIG) UI/交互设计规范，107 条核心强制条款 + **17 个分领域参考**（设计原则、布局、字体排印、颜色与深色模式、无障碍、组件、动效反馈、交互模式、文案与素材、材质与 Liquid Glass 含滚动边缘效果、包容性/隐私/RTL、输入方式、组件细则含边栏、模式细则、AI 与商业化、平台与游戏含 iPhone Duo、官方全量索引），含点击目标尺寸、对比度、字号等硬性数值 | 1.2.0 |

> 后续新增技能直接 `./add-skill.sh` 发布，见下文。

---

## 目录结构

```
skillbox/
├── plugins/                        # 所有技能本体，每个技能一个目录
│   ├── java-alibaba-dev-standard/
│   │   ├── SKILL.md                # 技能主文件（frontmatter 含 name/description/version）
│   │   └── references/             # 按需查阅的辅助文档
│   ├── vue-style-guide/
│   └── apple-hig-ui-standard/
├── .codebuddy-plugin/
│   └── marketplace.json            # [可选] CodeBuddy/WorkBuddy 市场索引
├── install.sh                      # 按需安装脚本（任何机器、任何平台可用）
├── add-skill.sh                    # 发布新技能进仓库
└── README.md
```

---

## 一、按需安装（两种方式任选）

### 方式 A：install.sh 脚本（推荐，轻量、跨平台）

```bash
git clone <你的仓库地址> skillbox
cd skillbox

./install.sh list                                   # 查看有哪些技能
./install.sh java-alibaba-dev-standard              # 安装指定技能
./install.sh --link java-alibaba-dev-standard       # 软链模式：git pull 后自动同步更新
./install.sh -f java-alibaba-dev-standard           # 强制覆盖已安装的同名技能
./install.sh --target ~/.cursor/skills xxx          # 指定安装到某个平台目录
./install.sh                                        # 不带参数：交互式选择
```

**安装目标自动检测**（按优先级）：

1. `SKILLS_HOME` 环境变量显式指定
2. 已存在的平台目录：`~/.claude/skills` > `~/.workbuddy/skills` > `~/.codebuddy/skills`
3. 都不存在时默认 `~/.claude/skills`（规范默认路径）

也可以显式指定：`./install.sh --target <目录> <技能名>`。

### 方式 B：CodeBuddy / WorkBuddy 市场（原生，可搜索）

把仓库克隆/复制到市场目录：

```bash
mkdir -p ~/.workbuddy/plugins/marketplaces
git clone <你的仓库地址> ~/.workbuddy/plugins/marketplaces/skillbox
```

之后在对话中说「安装 skill」或「搜索 skill」，即可按名搜索安装仓库中的任意技能（由 `.codebuddy-plugin/marketplace.json` 索引驱动）。

> 两种方式可并存。软链模式（`--link`）最适合自己用：本地 `git pull` 一次，所有已装技能同步更新。

---

## 二、添加新技能（发版流程）

### 用脚本（推荐）

先在本地开发好技能（含 `SKILL.md`，frontmatter 建议带 `name` / `description` / `version`），然后：

```bash
./add-skill.sh ~/.claude/skills/my-new-skill        # 描述自动从 SKILL.md 读取
./add-skill.sh ~/.claude/skills/my-new-skill "自定义描述"  # 或手动指定
```

脚本会：校验 → 复制进 `plugins/` → 自动更新 `marketplace.json`（可选索引）→ 提示提交。

### 手动

1. 把技能目录放进 `plugins/<技能名>/`
2. 如需 CodeBuddy/WorkBuddy 市场支持，在 `.codebuddy-plugin/marketplace.json` 的 `plugins` 数组加一条：

```json
{
  "name": "my-new-skill",
  "description": "技能简介（搜索时显示）",
  "version": "1.0.0",
  "source": "./plugins/my-new-skill"
}
```

### 提交推送

```bash
git add plugins/ .codebuddy-plugin/marketplace.json
git commit -m "feat(skill): add my-new-skill"
git push
```

---

## 三、首次推送到远程仓库

```bash
# 1. 在 GitHub / Gitee / CNB 等平台新建一个空仓库（不要勾选初始化 README）
#    复制仓库地址，例如 https://github.com/你的用户名/skillbox.git

# 2. 关联并推送
git remote add origin https://github.com/你的用户名/skillbox.git
git branch -M main
git push -u origin main
```

---

## 注意事项

- **SKILL.md 的 frontmatter**：`name` 要与目录名一致，`description` 写清楚触发场景（这决定了 AI 能否在正确时机自动加载技能）。
- **命名规范**：技能目录名仅允许字母/数字/`.`/`_`/`-`，以字母或数字开头。
- **软链模式**：`--link` 安装后不要删除仓库目录，否则软链失效；改用复制模式则无此限制。
- **安全**：从他人仓库安装技能前，先检查 SKILL.md 及其附带脚本是否存在可疑行为（下载执行、读取敏感文件等）。
