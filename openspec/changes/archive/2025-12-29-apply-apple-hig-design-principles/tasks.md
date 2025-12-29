# Tasks: Apply Apple HIG Design Principles

## 1. Typography Improvements

- [x] 1.1 Update `--font-size-base` from 1rem to 1.0625rem (17px) in `tokens.css`
- [x] 1.2 Adjust heading size scale for clearer hierarchy:
  - h1: 2.25rem (36px)
  - h2: 1.875rem (30px)
  - h3: 1.5rem (24px)
  - h4: 1.25rem (20px)
- [x] 1.3 Verify prose typography renders correctly after base size change
- [x] 1.4 Test mobile responsiveness of new typography scale

## 2. Color Contrast Fixes

- [x] 2.1 Calculate current contrast ratio for `--color-text-muted` on `--color-bg-page`
- [x] 2.2 Adjust `--color-text-muted` to achieve 4.5:1+ contrast (light mode): #7b6454 → #5f4d42
- [x] 2.3 Adjust `--color-text-muted` for dark mode to maintain consistency: #a88f80 → #b8a090
- [x] 2.4 Verify all muted text instances remain visually harmonious

## 3. Spacing Enhancements

- [x] 3.1 Increase article content area padding on BlogPost layout (skipped per user request)
- [x] 3.2 Review and adjust `--line-height-base` if needed (current 1.75 is good)
- [x] 3.3 Add more generous spacing between article sections (existing spacing adequate)
- [x] 3.4 Verify spacing on mobile breakpoints

## 4. Animation Simplification

- [x] 4.1 Simplify homepage `breathe` animation (already subtle: 0.05 opacity range)
- [x] 4.2 Reduce `fadeIn` animation duration for faster perceived load: 1.5s → 1s, 2s → 1.2s
- [x] 4.3 Ensure `prefers-reduced-motion` still works correctly (added media query to disable animations)

## 5. Validation

- [x] 5.1 Visual regression check across key pages (index, blog post, mangashots)
- [ ] 5.2 Lighthouse accessibility audit
- [ ] 5.3 Cross-browser testing (Chrome, Safari, Firefox)
- [x] 5.4 Run `pnpm build` to ensure no build errors

## Dependencies

- Tasks 1.x and 2.x can run in parallel
- Task 3.x depends on 1.x completion (spacing affected by font size)
- Task 4.x is independent
- Task 5.x must run after all other tasks complete
