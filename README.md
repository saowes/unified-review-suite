# unified-review-suite

一套可分发的 Cursor 审查扩展包：用**一个编排伞技能**作为唯一入口，把**文档一致性审查**与
**代码质量/安全审查**编排成一条统一流水线，并输出统一分级(P0–P3)报告。

## 它包含什么

| 组件 | 路径 | 作用 |
| --- | --- | --- |
| 编排伞技能 | `skills/review-orchestrator/` | 唯一入口；识别目标 → 路由 → 串流水线 → 汇总报告 |
| 文档审查技能 | `skills/document-review-sync-check/` | L1 引用存在性 / L2 参数一致性 / L3 反向传导 |
| 统一规则 | `rules/unified-review.mdc` | 共享严重度分级、问题归类、报告口径 |
| 自动化钩子 | `hooks/hooks.json` | 编辑文档后温和提醒可做同步检查(advisory，不阻断) |
| 命令入口 | `commands/review.md` | `/review` 一键发起统一审查 |
| 安装器 | `install.ps1` / `install.sh` | 一键部署到 Cursor 配置目录 |

代码审查能力**复用 Cursor 内置子代理**(`bugbot` / `security-review` / `code-reviewer`)，
由伞技能调度，不在本包内重写；内置子代理随 Cursor 提供，跨项目天然可用。

## 安装

> 装到**个人级 `~/.cursor/`** 后，所有项目自动可用；这是推荐方式。

Windows (PowerShell):

```powershell
./install.ps1                      # 装到 ~/.cursor(个人级，跨项目可用)
./install.ps1 -ProjectPath C:\repos\app   # 改装到某个项目的 .cursor/
./install.ps1 -SkipHooks          # 不安装自动化钩子
```

macOS / Linux:

```bash
chmod +x install.sh
./install.sh                       # 装到 ~/.cursor
./install.sh -p /path/to/repo      # 改装到某个项目的 .cursor/
./install.sh --skip-hooks          # 不安装自动化钩子
```

安装器会把 `skills/`、`rules/`、`commands/` 铺到对应目录，并**安全合并** `hooks.json`
(已存在则先备份再合并，不会覆盖你已有的钩子)。

## 使用

装好后只跟**一个入口**打交道：

- 直接说："用 review-orchestrator 做一次统一审查" / "对这次改动做全套审查"
- 或用命令：`/review`(可附目标路径、只跑文档线/代码线等)

伞技能会自动判断走文档线、代码线还是全量，并按统一模板输出 P0–P3 分级报告，
同时区分"内容问题(文档矛盾)"与"rollout 问题(实现/资源没跟上)"。

## 前提

- Cursor 设置中 **Skills 功能需开启**。
- 若环境不提供内置代码审查子代理，伞技能会自动降级为对照通用清单审查并在报告中标注。

## 设计说明

- **不物理合并技能**：内置子代理用"调度"而非"塞进一个文件"，避免破坏其能力，也符合
  Cursor "技能要专注"的建议。
- **伞技能依赖整包**：只装伞技能不足以工作，必须随包安装文档审查技能与规则。
- **自动化保守**：钩子仅做一行温和提醒，不在每次保存时强制跑全量审查。

## 致谢 / 来源

`document-review-sync-check` 源自 <https://github.com/saowes/-skill>（MIT）。

## License

MIT
