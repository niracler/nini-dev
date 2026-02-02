# Tasks: Add Yunxiao CLI Skill

## Phase 1: RED - Baseline Testing

> 目标：记录 Claude 在没有 skill 时如何处理云效相关任务

- [x] **1.1** 定义测试场景
  - 场景 A: "帮我在云效 Codeup 创建一个 MR"
  - 场景 B: "如何安装 git-repo 工具"
  - 场景 C: "帮我创建一个 Release tag 并推送到云效"
  - 场景 D: "查看我在云效 Projex 中的待办任务"

- [x] **1.2** 执行 baseline 测试（新会话，无 skill 上下文）
  - 记录 Claude 的回答
  - 记录错误信息或不准确之处
  - 记录 Claude 的 rationalizations（如果有）

- [x] **1.3** 分析 baseline 结果
  - 识别共同的问题模式
  - 确定 skill 需要解决的核心问题

## Phase 2: GREEN - Write Minimal Skill

> 目标：针对 RED phase 发现的问题，写最小化的 skill

- [x] **2.1** 创建 skill 目录结构

  ```
  repos/skill/src/yunxiao-cli/
  ├── SKILL.md
  └── references/
      ├── git-repo.md
      ├── push-review.md
      └── openapi.md
  ```

- [x] **2.2** 编写 SKILL.md 主文件
  - YAML frontmatter (name, description)
  - Overview + When to Use
  - Quick Reference 表格
  - 常见工作流

- [x] **2.3** 编写 references 文档
  - git-repo.md: 安装、配置、核心命令
  - push-review.md: 零安装方案
  - openapi.md: 阿里云 CLI + 云效 API

- [x] **2.4** 验证 skill 格式
  - frontmatter 符合规范
  - description 以 "Use when..." 开头
  - 关键词覆盖（CSO 优化）

## Phase 3: REFACTOR - Test and Close Loopholes

> 目标：测试 skill 效果，关闭漏洞

- [x] **3.1** 重新执行测试场景（带 skill）
  - 场景 A-D 全部重测
  - 对比 baseline 结果

- [x] **3.2** 识别新问题
  - Claude 是否正确引用 skill 内容？
  - 是否有遗漏的场景？
  - 是否有新的 rationalizations？

- [x] **3.3** 迭代优化
  - 补充遗漏内容
  - 添加 Red Flags 表格（如果需要）
  - 重测直到满意

## Phase 4: Finalize

- [x] **4.1** Commit skill 到 repos/skill
- [x] **4.2** 更新 skill 仓库的 README（如果需要）
- [x] **4.3** Archive 这个 change proposal
