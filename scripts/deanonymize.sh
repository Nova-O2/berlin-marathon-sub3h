#!/usr/bin/env bash
# deanonymize.sh — Clean up after paper acceptance
# Usage: bash scripts/deanonymize.sh
#
# After a paper is accepted:
# 1. Deletes the anonymous branch (local + remote)
# 2. Makes the repo public (manual step — prints instructions)

set -euo pipefail

BRANCH="anonymous"
MAIN_BRANCH="main"

echo "=== De-anonymize after Acceptance ==="

# Ensure we're on main
git checkout "$MAIN_BRANCH"

# Delete anonymous branch locally
if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
  git branch -D "$BRANCH"
  echo "  ✓ Local branch '$BRANCH' deleted"
fi

# Delete anonymous branch remotely
if git ls-remote --exit-code --heads origin "$BRANCH" &>/dev/null; then
  git push origin --delete "$BRANCH"
  echo "  ✓ Remote branch '$BRANCH' deleted"
fi

# Tag as accepted
read -p "Tag version (e.g., v1.0-accepted): " TAG
if [[ -n "$TAG" ]]; then
  git tag "$TAG"
  git push origin "$TAG"
  echo "  ✓ Tagged as $TAG"
fi

echo ""
echo "=== Done ==="
echo ""
echo "Manual steps remaining:"
echo "  1. Go to repo Settings → Danger Zone → Change visibility → Public"
echo "  2. Update README.md with DOI and citation info"
echo "  3. Create a GitHub Release with the accepted manuscript"
