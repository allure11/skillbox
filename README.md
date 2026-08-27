# WorkBuddy Skills 仓库

个人 WorkBuddy AI 技能（Skills）仓库。**一个仓库管理所有技能，按需安装**——不用把几十个技能全装进环境，用到哪个装哪个。

当前包含：

| Skill | 说明 | 版本 |
|---|---|---|
| [java-alibaba-dev-standard](plugins/java-alibaba-dev-standard/) | 阿里《Java 开发手册（嵩山版）》强制编码规范，308 条规约（强制 181 / 推荐 91 / 参考 36），覆盖命名、集合、并发、异常日志、单测、安全、MySQL、工程结构、设计 | 1.0.0 |

> 后续新增技能直接 `./add-skill.sh` 发布，见下文。

---

## 目录结构

```
workbuddy-skills/
├── plugins/                        # 所有技能本体，每个技能一个目录
│   └── java-alibaba-dev-standard/
│       ├── SKILL.md                # 技能主文件（frontmatter 含 name/description/version）
│       └── references/             # 按需查阅的辅助文档
├── .codebuddy-plugin/
│   └── marketplace.json            # 市场索引：WorkBuddy 原生按需安装靠它
├── install.sh                      # 按需安装脚本（任何机器可用）
├── add-skill.sh                    # 发布新技能进仓库
└── README.md
```

---

## 一、按需安装（两种方式任选）

### 方式 A：install.sh 脚本（推荐，轻量）

```bash
git clone <你的仓库地址> workbuddy-skills
cd workbuddy-skills

./install.sh list                    # 查看有哪些技能
./install.sh java-alibaba-dev-standard            # 安装指定技能
./install.sh --link java-alibaba-dev-standard     # 软链模式：git pull 后自动同步更新
./install.sh -f java-alibaba-dev-standard         # 强制覆盖已安装的同名技能
./install.sh                          # 不带参数：交互式选择
```

安装位置：`~/.workbuddy/skills/<技能名>/`（WorkBuddy 用户级技能目录，跨项目生效）。

### 方式 B：WorkBuddy 市场（原生，可搜索）

把仓库克隆/复制到 WorkBuddy 的市场目录：

```bash
mkdir -p ~/.workbuddy/plugins/marketplaces
git clone <你的仓库地址> ~/.workbuddy/plugins/marketplaces/workbuddy-skills
```

之后在 WorkBuddy 对话中说「安装 skill」或「搜索 skill」，即可按名搜索安装仓库中的任意技能（由 `.codebuddy-plugin/marketplace.json` 索引驱动）。

> 两种方式可并存。软链模式（`--link`）最适合自己用：本地 `git pull` 一次，所有已装技能同步更新。

---

## 二、添加新技能（发版流程）

### 用脚本（推荐）

先在本地 `~/.workbuddy/skills/` 里开发好技能（含 `SKILL.md`，frontmatter 建议带 `name` / `description` / `version`），然后：

```bash
./add-skill.sh ~/.workbuddy/skills/my-new-skill          # 描述自动从 SKILL.md 读取
./add-skill.sh ~/.workbuddy/skills/my-new-skill "自定义描述"   # 或手动指定
```

脚本会：校验 → 复制进 `plugins/` → 自动更新 `marketplace.json` → 提示提交。

### 手动

1. 把技能目录放进 `plugins/<技能名>/`
2. 在 `.codebuddy-plugin/marketplace.json` 的 `plugins` 数组加一条：

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
#    复制仓库地址，例如 https://github.com/你的用户名/workbuddy-skills.git

# 2. 关联并推送
git remote add origin https://github.com/你的用户名/workbuddy-skills.git
git branch -M main
git push -u origin main
```

---

## 注意事项

- **SKILL.md 的 frontmatter**：`name` 要与目录名一致，`description` 写清楚触发场景（这决定了 AI 能否在正确时机自动加载技能）。
- **命名规范**：技能目录名仅允许字母/数字/`.`/`_`/`-`，以字母或数字开头。
- **软链模式**：`--link` 安装后不要删除仓库目录，否则软链失效；改用复制模式则无此限制。
- **安全**：从他人仓库安装技能前，先检查 SKILL.md 及其附带脚本是否存在可疑行为（下载执行、读取敏感文件等）。
