# Design: Yunxiao CLI Skill

## Context

阿里云云效 (Yunxiao/Alibaba Cloud DevOps) 提供多种 CLI 工具，但文档分散、工具众多。用户主要使用场景：

1. 代码评审 (MR/PR)
2. 版本发布 (Release/Tag)
3. 任务管理 (Projex)

## Goals / Non-Goals

**Goals:**

- 整合云效 CLI 工具的关键命令
- 提供面向场景的工作流指南
- 让 Claude 能正确辅助云效操作

**Non-Goals:**

- 不覆盖所有云效功能（如制品库、效能度量）
- 不替代官方文档
- 不涉及流水线自定义步骤 (Flow-CLI step)

## Decisions

### 1. 工具优先级

| 场景 | 首选工具 | 备选工具 |
|------|----------|----------|
| 创建 MR | `git pr` (git-repo) | `git push -o review=new` |
| 更新 MR | `git pr` | `git push -o review=<id>` |
| 创建 Tag | `git tag` + `git push` | OpenAPI CreateTag |
| 查看任务 | 阿里云 CLI + OpenAPI | 网页端 |

**理由：** git-repo 提供更简洁的命令，Push Review Mode 作为无需安装的备选方案。

### 2. Skill 结构

采用与 `git-workflow` 相同的结构模式：

```
yunxiao-cli/
├── SKILL.md          # 概览 + 快速参考 + 常见工作流
└── references/
    ├── git-repo.md       # git-repo 安装与命令
    ├── push-review.md    # Push Review Mode
    └── openapi.md        # 阿里云 CLI + OpenAPI
```

**理由：** 保持 skill 仓库的一致性，用户熟悉这种结构。

### 3. 触发场景 (CSO)

SKILL.md description 应包含以下触发词：

```yaml
description: >
  Use when working with Alibaba Cloud DevOps (Yunxiao/云效), 
  including Codeup code review (MR/PR), git-repo commands (git pr, 
  git peer-review), push review mode, release tags, or Projex tasks.
```

### 4. 内容来源

| 内容 | 来源 |
|------|------|
| git-repo 安装 | https://git-repo.info/zh_cn/ |
| git-repo 命令 | https://help.aliyun.com/zh/yunxiao/user-guide/installation-and-configuration |
| Push Review Mode | https://help.aliyun.com/zh/yunxiao/user-guide/push-review-mode |
| OpenAPI | https://help.aliyun.com/zh/yunxiao/developer-reference/codeup-openapi-collection/ |

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| 云效 API 可能变更 | 标注文档版本和更新日期 |
| git-repo 安装复杂 | 提供 Push Review Mode 作为零安装方案 |
| Projex API 需要认证 | 文档说明 AccessToken 获取方式 |

## Open Questions (待 baseline 测试后确认)

1. Claude 在没有 skill 时最常犯的错误是什么？
2. 是否需要添加 troubleshooting 部分？
3. 是否需要覆盖更多场景？
