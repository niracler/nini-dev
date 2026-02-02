# Change: Apply Apple HIG Design Principles

## Why

Bokushi 博客当前设计系统已较为完善，但与 Apple Human Interface Guidelines 的核心原则存在差距：

1. **基础字号偏小** - 16px 低于 Apple 推荐的 17pt，影响长文可读性
2. **文字对比度不足** - muted text 在浅色背景上约 3.8:1，低于 WCAG AA 标准 4.5:1
3. **标题层级不够分明** - h1/h2/h3 字号跳跃不够明显
4. **留白可以更充分** - 内容区域需要更多呼吸空间
5. **动效可以更微妙** - 首页 breathe 动画稍显复杂

## What Changes

### Typography Improvements

- **MODIFIED** `--font-size-base` 从 1rem (16px) 提升到 1.0625rem (17px)
- **MODIFIED** 标题字号系统，增加层级差异
- **ADDED** 更明确的标题间距规范

### Color Contrast Fixes

- **MODIFIED** `--color-text-muted` 提高对比度至 4.5:1 以上
- **MODIFIED** Dark mode muted text 同步调整

### Spacing Enhancements

- **MODIFIED** 文章内容区 padding 增加
- **MODIFIED** 段落间距微调
- **ADDED** 内容呼吸感相关 token

### Animation Simplification

- **MODIFIED** 首页动画效果，更微妙不干扰

## Impact

- **Affected specs**: `design-system`
- **Affected code**:
  - `repos/bokushi/src/styles/tokens.css` - 核心 token 调整
  - `repos/bokushi/src/styles/global.css` - prose 样式微调
  - `repos/bokushi/src/pages/index.astro` - 动画简化
  - `repos/bokushi/src/layouts/BlogPost.astro` - 可能的间距调整

## Design Reference

Based on [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines):

- **Clarity**: Clean, precise interfaces with clear hierarchy
- **Typography**: 17pt default, clear size progression, 4.5:1+ contrast
- **White Space**: Ample space lets content shine
- **Animation**: Subtle, continuous, non-distracting
