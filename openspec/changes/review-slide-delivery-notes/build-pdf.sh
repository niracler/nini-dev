#!/bin/bash
# Build PDF from markdown files with page breaks between each file

set -e
cd "$(dirname "$0")/analysis"

# Create combined markdown with page breaks
OUTPUT_MD="/tmp/combined-slides.md"

# Add YAML front matter for better formatting
cat > "$OUTPUT_MD" << 'YAML'
---
title: "AI 编程分享：我之 AI 观"
subtitle: "从 Copilot 到 Claude Code 的踩坑之旅"
author: "讲稿备注"
date: "2025"
titlepage: false
toc: false
numbersections: false
colorlinks: true
linkcolor: blue
disable-header-and-footer: false
header-left: ""
header-center: ""
header-right: ""
footer-left: ""
footer-center: "\\thepage"
footer-right: ""
geometry: "a4paper,margin=2cm"
fontsize: "10pt"
linestretch: 1.0
listings-no-page-break: true
code-block-font-size: "\\tiny"
---

YAML

# Append each markdown file with page break between them
FIRST=true
for file in $(ls -1 *.md | sort); do
    if [ "$FIRST" = true ]; then
        FIRST=false
    else
        # Add page break before each new file (except first)
        # Use raw LaTeX block for reliable page breaks
        cat >> "$OUTPUT_MD" << 'PAGEBREAK'

```{=latex}
\newpage
```

PAGEBREAK
    fi

    # Append file content (skip any existing YAML front matter)
    cat "$file" >> "$OUTPUT_MD"
    echo "" >> "$OUTPUT_MD"
done

echo "Combined markdown created at: $OUTPUT_MD"

# Generate PDF
export PATH="/Library/TeX/texbin:$PATH"

pandoc "$OUTPUT_MD" \
    -o "../AI编程分享-讲稿.pdf" \
    --pdf-engine=xelatex \
    --template=eisvogel \
    -V mainfont="PingFang SC" \
    -V sansfont="PingFang SC" \
    -V monofont="Menlo" \
    -V CJKmainfont="PingFang SC" \
    --listings \
    2>&1 | grep -v "Missing character" || true

echo "✅ PDF generated: AI编程分享-讲稿.pdf"