## Why

Pinboard 书签管理存在两个问题：1) 313 个 tag 中存在大量拼写错误、大小写不一致、中英文重复、概念重叠等问题，且 14 条 bookmark 完全没有 tag，需要按规范整理；2) n8n 现有 pinboard workflow 只推送新增 shared bookmark，未读文章标记为已读后不会被推送到 Telegram，存在盲区。

## What Changes

- **新增 skill**: `pinboard-manager`，提供交互式 Pinboard 书签管理能力
  - Tag 审计模式：拉取全量 bookmark，按 tag 规范检查，批量展示问题，确认后通过 Pinboard API 修改
  - 死链检测模式：HTTP HEAD 检查所有链接，报告 404/超时/失效，用户决定删除或保留
  - 内置 tag 规范（全英文小写、`_` 连接、主题 tag + 元 tag 体系）
- **修改 n8n workflow**: 现有 `pinboard` workflow (ID: RpBf8OnthvmaZYjm) 增加已读推送分支
  - 分支 A（现有，修改）：`/posts/recent` → 过滤 `shared=yes AND toread≠yes` → hash 去重 → 推 Telegram
  - 分支 B（新增）：`/posts/all?toread=yes` → 对比 staticData 上次列表 → 消失的调 `/posts/get?url=` 验证是否还存在且 `shared=yes` → 确认已读后推送 Telegram

**涉及仓库**: `repos/skill`（skill 部分）、n8n.niracler.com（workflow 部分）

## Capabilities

### New Capabilities

- `pinboard-manager`: Pinboard 书签管理 skill，包含 tag 审计、死链检测、tag 规范定义

### Modified Capabilities

（无已有 spec 需要修改）

## Impact

- **新建**: `repos/skill/skills/workflow/pinboard-manager/SKILL.md`（skill 主文件）
- **新建**: `repos/skill/skills/workflow/pinboard-manager/references/tag-convention.md`（tag 规范文档）
- **修改**: n8n pinboard workflow — Function1 节点增加 `toread≠yes` 过滤，新增 toread diff 分支节点
- **触发词**: `pinboard 整理 tag` / `pinboard 检查死链` / `pinboard cleanup` / `pinboard audit`
- **依赖**: Pinboard API（`api.pinboard.in/v1/`，需要 auth_token）
- **审查依赖**: 实现完成后需调用 `skill-reviewer` 进行质量审计
- **Rollback**: 删除 `skills/workflow/pinboard-manager/` 目录；n8n workflow 回退到当前版本（version 17）
