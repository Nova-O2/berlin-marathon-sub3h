#!/usr/bin/env bash
# anonymize.sh — Create anonymous branch for peer review submission
# Usage: bash scripts/anonymize.sh
#
# Creates branch 'anonymous' from current HEAD with:
# - metadata.yaml replaced with blinded version
# - README.md stripped of author info
# - Original .docx manuscripts removed
# - Notebook outputs cleaned of local paths
# - Data files optionally anonymized (names column)
#
# After running, push the anonymous branch and use Anonymous GitHub
# (https://anonymous.4open.science/) to generate an anonymous link.

set -euo pipefail

BRANCH="anonymous"
MAIN_BRANCH="main"

echo "=== Anonymize for Peer Review ==="

# Ensure we're on main and clean
if [[ $(git status --porcelain) ]]; then
  echo "ERROR: Working tree is dirty. Commit or stash changes first."
  exit 1
fi

# Create or reset anonymous branch
git checkout -B "$BRANCH" "$MAIN_BRANCH"

# 1. Anonymize metadata.yaml
if [[ -f manuscript/metadata.yaml ]]; then
  cat > manuscript/metadata.yaml << 'YAML'
---
title: "[Title blinded for peer review]"
authors:
  - name: "[Blinded]"
    affiliation: "[Blinded]"
abstract: |
  [See manuscript]
keywords: []
date: 2026
lang: en
reference-section-title: References
---
YAML
  echo "  ✓ metadata.yaml anonymized"
fi

# 2. Anonymize README.md
if [[ -f README.md ]]; then
  cat > README.md << 'MD'
# [Title blinded for peer review]

> Anonymous repository for peer review. Full author information will be disclosed upon acceptance.

## Status

- **Phase:** Under Review

## Structure

```
data/          # Dataset
notebooks/     # Analysis notebooks
figures/       # Publication figures
manuscript/    # Manuscript (Markdown + BibTeX)
```
MD
  echo "  ✓ README.md anonymized"
fi

# 3. Anonymize LICENSE (remove organization name)
if [[ -f LICENSE ]]; then
  sed -i 's/Copyright (c) [0-9]* .*/Copyright (c) [Blinded for peer review]/' LICENSE
  echo "  ✓ LICENSE anonymized"
fi

# 4. Anonymize title_page.md and cover_letter.md
if [[ -f manuscript/title_page.md ]]; then
  cat > manuscript/title_page.md << 'MD'
**[TITLE BLINDED FOR PEER REVIEW]**

**Authors and Affiliations:** [Blinded for peer review]
MD
  echo "  ✓ title_page.md anonymized"
fi

if [[ -f manuscript/cover_letter.md ]]; then
  cat > manuscript/cover_letter.md << 'MD'
[Cover letter blinded for peer review]
MD
  echo "  ✓ cover_letter.md anonymized"
fi

# 5. Remove original .docx manuscripts (contain author names)
find manuscript/ -name "*.docx" -delete 2>/dev/null
echo "  ✓ Original .docx files removed"

# 6. Clean Windows paths from notebook outputs
if command -v python3 &>/dev/null; then
  python3 -c "
import json, glob, re
for nb_path in glob.glob('notebooks/*.ipynb'):
    with open(nb_path, 'r', encoding='utf-8') as f:
        nb = json.load(f)
    changed = False
    for cell in nb.get('cells', []):
        for i, output in enumerate(cell.get('outputs', [])):
            if 'text' in output:
                new_text = [re.sub(r'C:\\\\Users\\\\[^\\\\]+\\\\', '', line) for line in output['text']]
                if new_text != output['text']:
                    output['text'] = new_text
                    changed = True
    if changed:
        with open(nb_path, 'w', encoding='utf-8') as f:
            json.dump(nb, f, indent=1, ensure_ascii=False)
        print(f'  ✓ {nb_path} paths cleaned')
" 2>/dev/null || echo "  ⚠ Could not clean notebook paths (python3 not available)"
fi

# 7. Commit anonymous version
git add -A
git commit -m "chore: anonymize for peer review" --allow-empty

echo ""
echo "=== Done ==="
echo "Branch '$BRANCH' ready."
echo ""
echo "Next steps:"
echo "  1. git push origin $BRANCH"
echo "  2. Go to https://anonymous.4open.science/"
echo "  3. Paste: https://github.com/ORG/REPO/tree/$BRANCH"
echo "  4. Generate anonymous link for submission"
echo ""
echo "To return to main: git checkout $MAIN_BRANCH"
