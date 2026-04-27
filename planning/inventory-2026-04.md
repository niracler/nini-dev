# Planning Inventory 2026-04 — 精神断舍离盘点

> 时间窗：2026-03-22（过去 1 个月未完）～ 2026-07-22（未来 3 个月）
> 盘点日期：2026-04-22
> 数据源：7 维度 MECE 框架（A 工作 / B 代码 / C 个人创作 / D 日程 / E 自动化 / F 隐性 / G 存量）

## A. 工作承诺

### A1. 云效 Work Items

#### SylSmart

- [ ] YWQO-66 · [Tooling] export-openapi pre-commit hook 漏掉 submodule 指针变更 · 任务 · 待处理 · due:none · P中
- [ ] YWQO-16 · [System] "Collaborators" 功能客户验收发现缺失，需澄清是否等同于现有 member 管理 · 缺陷 · 待确认 · due:2026-04-22 · P中
- [ ] YWQO-15 · [Mesh] "Leave Area" 行为后端无对应能力，需先确认产品模型（per-area 访问控制是否引入） · 缺陷 · 待确认 · due:2026-04-24 · P中
- [ ] YWQO-14 · [Mesh] Group/Area 列表"按最后访问时间排序"功能缺失（需先评估前端 / 后端 / 不做） · 缺陷 · 待确认 · due:2026-04-24 · P中
- [ ] YWQO-13 · [Auth] 验证码邮件的发件人、品牌、正文、i18n 均不符合客户规范 · 缺陷 · 待确认 · due:2026-04-24 · **P高**
- [ ] YWQO-12 · [System] 项目名 (system_name) 允许输入 emoji 字符（无服务端校验） · 缺陷 · 待确认 · due:2026-04-22 · P中
- [ ] YWQO-11 · [Auth] 密码强度校验仅检查长度，未要求大写字母与特殊符号 · 缺陷 · 待确认 · due:2026-04-22 · **P高**
- [ ] YWQO-10 · [Auth] 4 个端点 email 字段缺少长度与格式校验 · 缺陷 · 待确认 · due:2026-04-23 · P中
- [ ] YWQO-9 · [Auth] 申请新验证码后旧码仍可影响新码的尝试次数 · 缺陷 · 待确认 · due:2026-04-24 · P中
- [ ] YWQO-8 · [Auth] 同邮箱大小写或空格差异下可重复注册 · 缺陷 · 已修复 · due:2026-04-24 · **P高**

#### Sunlite App

- [ ] MYCP-63 · 后台接口 · 标准需求 · 待梳理 · due:none · **P高**

### A1. 决策（2026-04-22）

**策略**：主动 push back / 分批交付（策略 1）。

**本周 triage 排期**（4/23 周四 / 4/24 周五 / 4/25 周六上班 · 每时段 2 条，不强求修完）：

| 时段 | 内容 |
|---|---|
| 周四上午 | 会议占据（AI 开发 9:30 + 产品设计 11:00），无 triage |
| 周四 14:00~15:30 | **YWQO-11** 密码强度 + **YWQO-12** emoji 校验 |
| 周四 15:45~17:30 | **YWQO-10** email 格式 + **YWQO-9** 旧码作废 |
| 周五上午 | **YWQO-14** 排序 + **YWQO-15** Leave Area |
| 周五 14:00~16:00 | EasyLighting Month-1 收尾（Calendar 已有） |
| 周五 16:00~17:30 | **YWQO-16** Collaborators 澄清 + **YWQO-8** 标为待验收（快速） |
| 周六上午 | **YWQO-13** 邮件模板 triage（大头） |
| 周六下午 | **YWQO-66** tooling + YWQO-13 如 triage 通过就开工 |

**今天 4/22 下班前必做**：云效上把 YWQO-11 / YWQO-12 的 due 改到 4/23（避免明早开系统看到"已过期"自扣心血）。

**Ownership 争议 flag**（triage YWQO-14/15/16 时同步提出）：

- YWQO-14「按访问时间排序」：需评估前端 / 后端 / 不做 —— 产品决策
- YWQO-15「Leave Area」：后端无对应能力 —— 产品模型决策
- YWQO-16「Collaborators」：判定 UI 命名还是新概念 —— 产品澄清

**本周产能约束**：A 吃满 ~24h 可用产能。**其他 6 类（D/G/F/C/B/E）本周 0 投入**。下次 session 从**下周 4/27 周一**起推 D。

### A2. 工作即时通讯承诺

**决策（2026-04-22）**：严格定义下 = **全空**。所有承诺类 IM 均已回复。

剩余技术落地挂在 B 类 4/24 下午 2h block 里处理：

- Homey 论坛帖 (community.homey.app/t/.../65588/221) — 维护者响应
- GitHub issue `Koenkk/zigbee2mqtt#31129` — Sunricher 设备 triage
- Cissy IM 的 UI 建议 — Homey app P1/P2 outputs 布局评估

**flag（下次盘点改进）**：B1 扒取范围 `gh issue --assignee @me` 漏了"维护者责任型"issue。下次盘点需加特定 repo 监控（zigbee2mqtt / homey-sdk）+ 社区论坛 mention。

## B. 代码协作

### B1. GitHub 在途 issues/PRs

#### ha-dev

- [ ] maginawin/ha-dali-center · #80 · [Feature]: Support Power On CCT Level and System Failure CCT Level configuration · (since 2026-04-03) · [enhancement]
- [ ] maginawin/PySrDaliGateway · #29 · HA cannot discover the gateway · (since 2025-11-28)
- [ ] maginawin/ha-dali-center · #56 · [Bug]: Light:Toggle in HA on DALI group doesn't work without brightness slider · (since 2025-11-20) · [bug]
- [ ] maginawin/ha-dali-center · #53 · [Feature]: Enhance Device Configuration Capabilities within HA · (since 2025-11-13)
- [ ] maginawin/ha-dali-center · #42 · [Feature]: Manual gateway IP input (SADP/mDNS blocked) · (since 2025-09-17)
- [ ] maginawin/ha-dali-center · #40 · [Bug]: Can't control DALI drivers after 3-4 continuous ops · (since 2025-09-12) · [bug, needs info]

#### homey-dev

- [ ] easyhomesrc/homey_slc_smartone_v3 · #6 · S57003 - Add features in "when" · (since 2025-07-25)
- [ ] PR vincent-iQontrol/Homey-iCasa-Zigbee-Driver · #1 · feat: scene support for Pulse 8S/4S/Remote · (since 2026-02-10)

#### nini-dev

- [ ] niracler/bokushi · #1 · FIRST ISSUE: 100 个个人网站可以做的事情 · (since 2025-05-30)
- [ ] niracler/nyaruko-telegram-bot · #22 · [BUG] Cannot obtain token/characterid for xlog email reg · (since 2024-01-25) · ⚠️ repo 已归档
- [ ] niracler/nyaruko-telegram-bot · #21 · [Feature] Embedding search for channel · (since 2024-01-25) · ⚠️ repo 已归档
- [ ] niracler/nyaruko-telegram-bot · #14 · [BUG] No username config → '@' activates AI robot · (since 2024-01-25) · ⚠️ repo 已归档
- [ ] niracler/nyaruko-telegram-bot · #10 · [Feature] Auto channel tag · (since 2024-01-25) · ⚠️ repo 已归档
- [ ] niracler/nyaruko-telegram-bot · #8 · [Feature] Allow user list manage · (since 2024-01-25) · ⚠️ repo 已归档
- [ ] niracler/nyaruko-telegram-bot · #7 · [Feature] debug mode for nyaruko · (since 2024-01-25) · ⚠️ repo 已归档

#### z2m-dev

- [ ] PR zigpy/zha-device-handlers · #4878 · feat(sunricher): quirk for SR-ZG9032A-PIR · (since 2026-03-30)

#### orphan（无 workspace 归属）

- [ ] niracler/animashin · #4 · Anything I should do in v0.0.1 · (since 2025-01-06)
- [ ] niracler/nyaruko · #10 · [Feature] Setup a telegram bot to collection channel message · (since 2023-10-12) · ⚠️ repo 已归档
- [ ] niracler/nyaruko · #8 · [Feature] Person status sync · (since 2023-10-11) · ⚠️ repo 已归档
- [ ] niracler/nyaruko · #7 · [Feature] Publish kb articles to GitHub / xLog · (since 2023-10-11) · ⚠️ repo 已归档
- [ ] niracler/nyaruko · #6 · [Feature] Random topic each month · (since 2023-10-11) · ⚠️ repo 已归档
- [ ] niracler/nyaruko · #5 · [Feature] Sync short article via TG bot · (since 2023-10-11) · ⚠️ repo 已归档
- [ ] niracler/nyaruko · #4 · [Feature] Sync pinboard to obsidian weekly · (since 2023-10-11) · ⚠️ repo 已归档
- [ ] niracler/nyaruko · #3 · [Feature] Embedding paragraph from my blog with openai · (since 2023-10-11) · ⚠️ repo 已归档
- [ ] niracler/nyaruko · #1 · [Feature] Import articles into SQLite · (since 2023-10-11) · ⚠️ repo 已归档
- [ ] UMLTeam/DearHouAimin · #231 · 教学资源所有模块都缺资源 · (since 2019-01-07) · ⚠️ 大学项目 7 年前

### B2. OpenSpec 未归档变更

#### homey-dev

- easylighting-code-style-unify · EasyLighting 引入 Prettier/ESLint/editorconfig + lint-staged

#### ha-dev

- add-light-group-platform · sunricher_dali 新增 Light Group 平台 + HA DaliLightGroup 实体
- add-sunricher-dali-diagnostics · sunricher_dali 新增 diagnostics.py 实现 Gold 级 diagnostics

#### z2m-dev

- zha-quirk-sr-zg9032a-pir · ZHA V2 quirk：SR-ZG9032A-PIR 暴露 Sunricher 厂商私有属性

#### nini-dev / srhome-dev / ai-dev

- （无）

### B3. Planning YAML 在途 modules

#### nini-dev/nini-dev-2026-03

- [ ] bokushi-blog · 博客周更 · weeks:[W1,W2,W3,W4] · 每周至少 1 篇博客
- [ ] bokushi-health · Health 每日更新 · weeks:[W1,W2,W3,W4]
- [ ] ai-share-archive · AI 分享归档 · weeks:[W3,W4]

#### nini-dev/cs146s（10 个 module 全 planned，但课程已到 W5）

- [p] w1-llm-intro · W1 - LLM 基础与有效提示 · weeks:[W1]
- [p] w2-coding-agents · W2 - Coding Agent 解剖 · weeks:[W2]
- [p] w3-ai-ide · W3 - AI IDE · weeks:[W3]
- [p] w4-agent-patterns · W4 - Coding Agent 协作模式 · weeks:[W4]
- [p] w5-terminal · W5 - 现代终端 · weeks:[W5]
- [p] w6-testing-security · W6 - AI 测试与安全 · weeks:[W6]
- [p] w7-code-review · W7 - 现代代码审查与文档 · weeks:[W7]
- [p] w8-ui-app · W8 - 自动化 UI 与 App 构建 · weeks:[W8]
- [p] w9-post-deployment · W9 - 上线后的 Agent · weeks:[W9]
- [p] w10-future · W10 - AI 软件工程的未来 · weeks:[W10]

#### homey-dev/easylighting

- [ ] code-style-unify · ESLint 统一 · weeks:[W2]
- [p] dep-update · 依赖更新 · weeks:[W3,W4]
- [p] ts-setup · TypeScript 编译基础设施 · weeks:[W5]
- [p] lib-ts-migration · lib/ TS 迁移（33 文件） · weeks:[W6,W7,W8]
- [p] driver-ts-migration-zigbee · Zigbee 驱动 TS 迁移（~70 个） · weeks:[W9,W10,W11]
- [p] driver-ts-migration-zwave · Z-Wave 驱动 TS 迁移（~17 个） · weeks:[W11,W12]
- [p] app-ts-migration · app.js TS 迁移 · weeks:[W12,W13]

#### ha-dev/ha-dev（**20 个 module 全 planned，覆盖 W1-W24**）

- [p] azoula-scene-platform · weeks:[W1,W2]
- [p] azoula-event-platform · weeks:[W3,W4]
- [p] azoula-sdk-extraction · weeks:[W5,W6]
- [p] azoula-core-init-pr · weeks:[W7,W8]
- [p] dali-gold-repair-issues · weeks:[W1,W2]
- [p] azoula-group-platform · weeks:[W9,W10]
- [p] azoula-core-sensor-pr · weeks:[W11,W12]
- [p] azoula-core-switch-pr · weeks:[W13,W14]
- [p] azoula-core-scene-pr · weeks:[W15,W16]
- [p] dali-gold-reconfiguration-flow · weeks:[W9,W10]
- [p] dali-gold-docs-devices · weeks:[W11,W12]
- [p] dali-gold-dynamic-devices · weeks:[W13,W14]
- [p] dali-gold-docs-misc · weeks:[W15,W16]
- [p] azoula-core-event-pr · weeks:[W17,W18]
- [p] azoula-core-group-pr · weeks:[W19,W20]
- [p] azoula-options-flow · weeks:[W21,W22]
- [p] azoula-core-quality-pr · weeks:[W23,W24]
- [p] dali-gold-stale-devices · weeks:[W17,W18]
- [p] dali-light-group · weeks:[W19,W20]
- [p] dali-gold-docs-final · weeks:[W23,W24]

#### ai-dev/ai-dev

- [p] openspec-training · OpenSpec 概念培训 · weeks:[W1]
- [p] ai-dev-report · AI 开发从入门到精通报告 · weeks:[W1]
- [p] showcase-monorepo · OpenSpec Showcase monorepo 改造 · weeks:[W2,W3]
- [p] planning-promotion · Planning 方案推广 · weeks:[W3,W4]

#### srhome-dev/sylsmart (month-2)

- [p] user-preferences · weeks:[W8]
- [p] mesh-group-scene · 区域/分区/场景增强 · weeks:[W5,W6,W7]
- [p] mesh-provisioning · 设备配网 API · weeks:[W6,W7,W8]
- [p] invalidate-old-verification-codes · weeks:[W7]
- [p] auth-validation-hardening · weeks:[W7]
- [p] email-template-revamp · weeks:[W7]
- [p] customer-review-mesh-followup · weeks:[W7]
- [p] customer-review-collaborators-clarification · weeks:[W7]

#### srhome-dev/sylsmart (month-4)

- [p] settings-api · weeks:[W14]
- [p] scheduling-api · weeks:[W14]
- [p] ota-api · weeks:[W16]
- [p] notification-api · weeks:[W17]

### B. 决策（2026-04-22）

**B1. GitHub 在途 clean-up**：

- 已 close 14 条归档 repo 的老 issues：`niracler/nyaruko` 8 条 + `niracler/nyaruko-telegram-bot` 6 条（unarchive → close → re-archive）
- `UMLTeam/DearHouAimin#231` 放弃（别人的 archived repo）
- 活跃 repo 的 issues/PRs **全部保留**（维护者责任 + 等 reviewer 反馈）
- Self-correct：inventory 曾错把 `niracler/nyaruko` 标 archived，实际未 archive

**B2. OpenSpec 未归档**：4 条全部保留，绑定 B3 modules。`z2m-dev/zha-quirk-sr-zg9032a-pir` 保持孤立 change（无 yaml 背书，脑子里记着）。

**B3. Planning YAML 时间调整**（核心策略：**不砍 module，只延长时间**）：

| yaml | 原 | 调整后 | 理由 |
|---|---|---|---|
| `nini-dev-2026-03` | 3-01 ~ 3-31（过期）| **建新 `nini-dev-2026-04.yaml`** 承接 3 条 in_progress | 月度 yaml |
| `easylighting` | 14 周 → 7-11 | **27 周 → 10-11** | easylighting 仅 1 d/w 可用 |
| `ha-dev` | W1-W24 并行 → 8-21 | **W1-W51 阶段化 → 2027-02-28** | DALI Gold 先 (W1-W24)，Azoula 后 (W25-W51) |
| `ai-dev` | 3-06 ~ 3-31（过期）| **5-01 ~ 5-31**（整体 shift 到 5 月） | timeline 过期 |
| `sylsmart` | 3-09 ~ 7-10 | **不动** | client deadline 硬约束 |
| `cs146s` | 10 planned | **全 10 deferred，Q3 reconsider** | D 类连锁决策 |

**统一月度排期**：见 session 最后消息里的 mermaid gantt + 月度 focus 表。

**核心 insight**：sylsmart (3 d/w) + ha-dev (2 d/w) 占 5 d/w = 工作日全占。easylighting / ai-dev / nini-dev 只能用"业余"时间。ai-dev 4 条集中 5 月完成；ha-dev Phase 1 占 3 月~8 月，Phase 2-3 占 8 月~2027-02。

## C. 个人创作

### C1. Random 月度挑战

- [ ] 系统已中断 — Random History 停在 2025-03，一年多未补 · (README.md L20-34)
- [ ] prompt.md Node.js/TypeScript 复习计划 9 条 step 全未勾选 · (2024 年遗留模板)
- [x] random-manage skill 搭建完成（commit `a94ffca`，mutation 集成测试 deferred 到首次实用时）

### C2. bokushi 草稿

（无）`src/content/monthly/` 最新两篇 `2603.mdx`、`2604-1.mdx` 均已发布；无 draft、无 drafts/、无 TODO/WIP 文件。

### C3. 笔记 TODO

#### Obsidian 日记（真实一次性 TODO）

- [ ] 衣架 · (2026-04-18)
- [ ] 棉签 · (2026-04-18)
- [ ] 手机支架 · (2026-04-18)
- [ ] 牙膏 · (2026-04-18)
- [ ] [[Topic 寿司郎]] · (2026-04-14)

#### 日记模板型 checkbox（日常习惯，非一次性）

- [ ] [[Health - Daily Check]] · 近 30 天 ~20 篇未勾选（模板项）
- [ ] [[How Do You Live?]] · 近 30 天 ~30 篇几乎未勾选（人生宪法 review）
- [ ] [[Pinboard reorganize]] · 近 30 天 ~10 次未勾选
- [ ] [[Obsidian reorganize]] · 近 30 天 ~10 次未勾选

#### plrom 辅助

- [ ] CHANGELOG.md 空 `[Unreleased]` section — 2026-04 月度更新尚未开始

## D. Apple 日程

### D1. Calendar 事件 (2026-04-22 ~ 2026-07-22)

#### Personal - CS146S 课程（每周 2 次）

- 2026-04-23 20:00 · [CS146S] W5 Agentic Dev with Warp
- 2026-04-28 20:00 · [CS146S] W6 AI 测试与安全
- 2026-04-30 20:00 · [CS146S] W6 Writing Secure AI Code
- 2026-05-05 20:00 · [CS146S] W7 代码审查与文档
- 2026-05-07 20:00 · [CS146S] W7 Code Review Reps
- 2026-05-12 20:00 · [CS146S] W8 自动化 UI/App 构建
- 2026-05-14 20:00 · [CS146S] W8 Multi-stack Web App Builds
- 2026-05-19 20:00 · [CS146S] W9 上线后的 Agent
- 2026-05-21 20:00 · [CS146S] W9 Incident Response 深化
- 2026-05-26 20:00 · [CS146S] W10 AI 软件工程的未来
- 2026-05-28 20:00 · [CS146S] W10 总复习

#### Personal - 其他

- 2026-05-09 19:30 · 同事 M 寿司郎

#### Work - 固定会议

- 2026-04-22 09:30 · Sunlite App场景中删除/新增设备补充自动化需求 · 五楼会议室 2
- 2026-04-22 18:30 · 《七个习惯》2.0 第十四讲 · 人事部会议室
- 2026-04-23 09:30 · AI 开发: PM 8-stage 访谈落地(事前准备)
- 2026-04-23 11:00 · AI 协助产品设计的二三事 · 五楼会议室 2
- 2026-04-24 14:00 · EasyLighting: Month-1 收尾
- 2026-04-27 09:30 · AI 开发: Codex → Figma prototype demo
- 2026-04-27 20:00 · 七个习惯课后感 - 第十四/十五讲
- 2026-04-28 09:30 · HA 集成: DALI Gold repair-issues
- 2026-04-29 18:30 · 《七个习惯》2.0 第十五讲
- 2026-05-11 20:00 · 七个习惯课后感 - 第十六/十七讲
- 2026-05-25 20:00 · 七个习惯课后感 - 第十八/十九讲
- 2026-06-08 20:00 · 七个习惯课后感 - 第二十/二十一讲
- 2026-06-22 20:00 · 七个习惯课后感 - 第二十二/二十三讲
- 2026-07-06 20:00 · 七个习惯课后感 - 第二十四/二十五讲

#### Scheduled Reminders（⚠️ 与 D2 Reminders 重复显示）
>
> 这一组事件是 Apple Reminders 在 Calendar 里的映射，**不算新增承诺**，只是同事在两处可见。约 50 条（日常习惯 + 人际联络 + 开发任务）。

#### 中国大陆节假日

- 2026-05-01 · 劳动节（休）· 2026-05-09 · 劳动节（班）
- 2026-05-05 · 立夏 · 2026-05-21 · 小满
- 2026-06-05 · 芒种 · 2026-06-19 · 端午节
- 2026-06-21 · 夏至 · 2026-07-07 · 小暑

### D2. Reminders 未完成

#### 提醒

- [ ] 看《超时空辉夜姬》新番 · due:2026-04-27
- [ ] CS146S｜第 8 周检查点 · due:2026-04-27
- [ ] CS146S｜第 12 周阶段复盘 · due:2026-05-25
- [ ] 订寿司郎位置（先按 5/1 晚上） · due:2026-04-24
- [ ] 订寿司郎位置（先按 5/9 晚上） · due:2026-05-02
- [ ] HA: Azoula SDK 独立抽取为独立 Python 库 · due:2026-04-25
- [ ] HA 集成: DALI Gold repair-issues + diagnostics · due:2026-04-25
- [ ] EasyLighting: ESLint 配置和代码格式化 · due:2026-04-25
- [ ] AI 开发: PM 8-stage 访谈落地 · due:2026-04-23
- [ ] AI 开发: Codex → Figma prototype demo · due:2026-04-23
- [ ] HA 集成: DALI Gold repair-issues · due:2026-04-24
- [ ] EasyLighting: Month-1 收尾 (依赖更新) · due:2026-04-24

#### 阅读（Read）

- [ ] 漫画表情包整理什么的 · due:2026-04-22
- [ ] 《用户体验要素》 · due:none

#### 人际关系（Relationship）—— **22 个**

- [ ] Haruki · due:2026-04-24
- [ ] 小麦(小 M) · due:2026-04-23
- [ ] Yu君 · due:2026-04-28
- [ ] 曾攀 · due:2026-05-07
- [ ] 父母 · due:2026-04-27
- [ ] Gary · due:2026-04-25
- [ ] 林源 · due:2026-04-27
- [ ] 黄凯杰 · due:2026-05-07
- [ ] 梁减减 · due:2026-05-19
- [ ] Raye · due:2026-05-17
- [ ] 小风 · due:2026-05-18
- [ ] Chang Kaishen · due:2026-04-25
- [ ] 梁光满 · due:2026-04-30
- [ ] LavaC · due:2026-04-26
- [ ] 一个月找一个旧朋友 · due:2026-04-24
- [ ] XXX · due:2026-05-04
- [ ] 李启林 · due:2026-04-25
- [ ] 李梓毅 · due:2026-05-04
- [ ] 维护人际关系｜可以试着写明信片什么的 · due:none
- [ ] gledos · due:2026-04-23
- [ ] 何同学 · due:2026-05-09
- [ ] 约胡伟飞吃寿司郎（6/6-6/7） · due:2026-06-01

#### 健康（Health）

- [ ] 进行全身体检 · due:2026-09
- [ ] 每周1次市场 | 菜和水果 | 预算 80 · due:2026-04-24
- [ ] 运动中期检查（周期过半，目标应完成5次+） · due:2026-04-26
- [ ] 出门前涂防晒（痘印恢复 Rule #1） · due:2026-04-23

#### 生活（Life）

- [ ] 双周记《202604-2》开始编写 · due:2026-04-25
- [ ] 双周记《202604-2》发布 · due:2026-04-25
- [ ] 双周记《202605-1》开始编写 · due:2026-05-02
- [ ] 双周记《202605-1》发布 · due:2026-05-09
- [ ] 起床动作 (20min)... · due:2026-04-23 · Plow
- [ ] 每个月看一部电影 · due:2026-04-26
- [ ] 多邻国 Duolingo · due:2026-04-23
- [ ] 搞卫生 · due:2026-04-25
- [ ] 头套被单清洗 · due:2026-04-30
- [ ] 清洁洗衣机 · due:2026-04-29
- [ ] YNAB 记账 · due:2026-05-15

#### 物联网（IoT）

- [ ] 我或许可以一个月买一个智能家居设备 · due:2026-05-14
- [ ] HA Cloud 深入探索：CO2 浓度自动播报等玩法 · due:2026-05-20

### D. 决策（2026-04-22）

**D2 Reminders（53 → 保 36 / 移 17，砍 32%）**：

| 子类 | 总 | 保 | 移 |
|---|---|---|---|
| 人际关系 | 22 | 15 | 7 |
| 提醒 | 12 | 9 | 3 |
| 阅读 | 2 | 1 | 1 |
| 健康 | 4 | 4 | 0 |
| 生活 | 11 | 7 | 4 |
| 物联网 | 2 | 0 | 2 |

**具体移除**：

- 人际：gledos、Chang Kaishen、曾攀、梁光满、李启林、「一个月找一个旧朋友」、「写明信片」
- 提醒：CS146S 检查点 × 2、订寿司郎 5/1
- 阅读：《用户体验要素》→ **移入 Random 作为高优先级事项**
- 生活：双周记相关 4 条（删 Reminder 继续写，信内驱力）
- 物联网：一个月买一个 IoT 设备（删）、HA Cloud CO2 播报 → **移入 Random「买摄像头」月份**

**D1 Calendar（删 17 条）**：

- CS146S 11 个课程事件（4/23~5/28）
- 《七个习惯》课后感 6 场（4/27~7/6，周一 20:00）
- 保留：Work 固定会议、《七个习惯》正课、同事 M 寿司郎 5/9、中国大陆节假日

**连锁影响**：

- `nini-dev/planning/schedules/cs146s.yaml` 10 modules → `planned` → `deferred`，备注 "2026-Q3 reconsider"
- 《用户体验要素》+ HA Cloud 探索 → 下次 Random 规划时入池

**规则清单（为未来人际 Reminder 维护）**：

1. **准入准则**：铁哥们才入 Reminder，不然怕忘记（父母、密友 → 入；泛交 → 不入）
2. **Reminder 本质**：timer-based check（30 秒决定要不要动作），不是打卡
3. **保持型子类**：日常接触版（小麦）/ 远程互动版（Gary）
4. **照顾型**：单向关系，触发需要明确动作（Haruki）
5. **退出条件**：关系淡了（gledos）或对方转型（新伴侣等）

**D 类总计**：113 → 79（砍 30%）

## E. 自动化 / 订阅

### E1. 自动化任务（`~/.claude/scheduled-tasks/`）

> 不占手动产能，跑在 cron。

- ha-community-daily — HA 社区动态、官方博客、release、插件反馈（weekly）
- homey-community-daily — Homey 社区 + GitHub issues + SDK + 竞品（weekly）
- openclaw-changelog-watch — OpenClaw release/commit 监控（daily）
- openclaw-oauth-check — OpenClaw OAuth scope 修复检查（daily）
- skill-evolve — Claude Code 配置体检 + skill 演化 + memory 清理（weekly）
- z2m-sunricher-monitor — Z2M / Sunricher 生态 / zigbee-herdsman 变化（weekly）

### E2. 生活周期性（留白 — 你补）

> 账单 / 订阅 / 保险 / 体检 / 续费 / 家电维修 等。
>
> - [ ] ________

## F. 隐性承诺

### F1. 社交承诺（留白 — 你补）

> D2 Reminders「人际关系」已覆盖 22 个；这里补 D2 外的：想联络但没记的人 / 欠的人情 / 延误的回复。
>
> - [ ] ________

### F2. 财务 / 学习 / 阅读积压（留白 — 你补）

> 想做的财务决策 / 买了没读的书 / 订的课没上 / RSS 积压 / 想看没看的电影。
>
> - [ ] ________

## G. 存量审视（plrom README）

> Agent 5 已完成：44 个子分类 / 150+ 条目 / 每类 1-2 条引导问题。
> 完整输出留存在 session context（未合并入此文件）。
> 理由：plrom README 本身就是 canonical 来源，重复列在此处只会让 inventory 多涨 500 行，反向加重注意力成本。

### G. 决策（2026-04-22）

**本次 session 跳过 G 类详细审视**，因 44 子类 × 决策成本太高，单次处理不合适。

**绑定机制**（防止永久 deferred）：G 的断舍离工作**并入 `plrom` monthly update 流程**。每月 plrom release（例如 `v2026.05`）时强制 review 1-2 个子类，按"低悬果子"优先清。12 个月内完整过一遍 44 子类。

**低悬果子清单**（作为 5 月 plrom update 起点，按 Claude 筛选的用户自述问题项）：

**硬件 — 设 deadline 处理**：

- Xbox Series S / Sony WH-XB910N —「想出手」→ 本月挂闲鱼地板价
- Switch 续航版 / iPhone SE 2 / Kindle Paperwhite 4 —「想送人」→ 设具体 deadline 送出
- 倍控工控主机 J1900 —「没发现具体用途」→ 3 月 deadline，没启用就卖
- 米家空气净化器 5 / 香氛机 / 筋膜枪 2C / 吹风机 H301 —「吃灰 / 微妙 / 更靠谱的替代」→ 送 / 卖

**软件 + 订阅 — 直接清理**：

- Setapp ¥360/y —「消费主义陷阱，不打算继续」→ **立刻取消**
- 多邻国 ¥40/y —「不想继续了」→ 续费日不续
- Figma MCP /  superpowers —「装了没用起来 / 跟官方重复」→ uninstall
- 脉脉 —「不顺畅」→ 不找工作则卸
- Affinity Photo 2 ¥688 —「只用到基础功能」→ sunk cost 接受
- Folo $100/y — vs 原生 RSS 二选一
- AdGuard $18.37 —「效果一般没配好」→ 补配或换免费
- CleanShot X —「没用上高级功能」→ 系统截图够用

**额外强推**：年度订阅 total 审视——下次 plrom release 的 CHANGELOG 里加一节「年度订阅总账」，强制算账（Claude Code $1200 + Folo + YNAB + 1P + iCloud + 阿里云盘 + Setapp + ...）。

**G1 人（~95 条）**：由你自己过，标准「最近 3 个月真的读/看/听过吗？」；注意漫画家列表里「创山谏」+「谏山创」是同一人，至少合并。

**G2 组织**：少数派（自述"买买买源头"）可考虑移出主动关注；HN + SuperTechFans 二选一。
