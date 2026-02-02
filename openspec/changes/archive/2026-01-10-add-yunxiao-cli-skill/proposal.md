# Proposal: Add Yunxiao CLI Skill

## Summary

为 skill 仓库添加阿里云云效 (Yunxiao) CLI 工具的 skill，整合代码评审、版本发布、任务管理等场景的命令参考和工作流指南。

## Motivation

云效提供多种 CLI 工具（git-repo、Push Review Mode、阿里云 CLI + OpenAPI），但：

- 文档分散在不同页面
- 工具之间的选择不明确
- Claude 目前不了解这些工具的存在和用法

## Scope

**包含：**

- git-repo 安装与核心命令（`git pr`, `git download`, `git peer-review`）
- Push Review Mode（零安装方案）
- 阿里云 CLI 调用云效 OpenAPI（Tag、Projex 任务）
- 面向场景的工作流指南

**不包含：**

- Flow-CLI 流水线自定义步骤
- 制品库、效能度量等其他云效功能
- 完整的 OpenAPI 参考（链接到官方文档）

## Approach

采用 TDD 流程创建 skill：

1. **RED Phase** - 在没有 skill 的情况下测试 Claude 处理云效任务的表现，记录问题
2. **GREEN Phase** - 针对发现的问题写最小化 skill
3. **REFACTOR Phase** - 测试并关闭漏洞

Skill 结构参考 `git-workflow`：主文件 + references 文件夹。

## Success Criteria

- Claude 能正确指导用户安装 git-repo
- Claude 能正确使用 `git pr` 或 push review mode 创建 MR
- Claude 能正确指导创建 Release/Tag
- Claude 能正确指导查看 Projex 任务

## References

- [git-repo 安装配置](https://help.aliyun.com/zh/yunxiao/user-guide/installation-and-configuration)
- [git-repo 官方文档](https://git-repo.info/zh_cn/)
- [云效 Codeup OpenAPI](https://help.aliyun.com/zh/yunxiao/developer-reference/codeup-openapi-collection/)
- [推送评审模式](https://help.aliyun.com/zh/yunxiao/user-guide/push-review-mode)
