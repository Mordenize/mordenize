#!/bin/bash
# Get staged SCSS/CSS files
STAGED_FILES=$(git --no-pager diff --cached --name-only --diff-filter=AMCR | grep -E '\.(scss|css)$' || true)

# Exit if no SCSS/CSS files are staged
if [ -z "$STAGED_FILES" ]; then
  echo "👍 No staged SCSS/CSS files to lint."
  exit 0
fi

# Run check Stylelint rules on staged files
# 2>&1 redirects STDERR to STDOUT
STYLELINT_OUTPUT=$(npx stylelint $STAGED_FILES 2>&1 || true)

if [ -n "$STYLELINT_OUTPUT" ]; then
  echo "$STYLELINT_OUTPUT"
  read -p "> Fix issues? (y/n): " CHOICE

  if [ "$CHOICE" = "y" ]; then
    echo "🛠️ Fixing Stylelint issues in staged files..."
    STYLELINT_FIX_OUTPUT=$(npx stylelint --fix $STAGED_FILES 2>&1 || true)

    # Re-add file again if not have error
    if [ -n "$STYLELINT_FIX_OUTPUT" ]; then
      echo "❗Stylelint doesn't support autofix rules like 'color-named'..." 
      echo "❌ Stylelint encountered errors. Please check manually."
      exit 1
    fi

    echo "👍 Stylelint fixes applied. Re-adding files to Git..."
    git add $STAGED_FILES
    echo "📌 Files re-added successfully."
  else
    echo "❌ Stylelint encountered errors. Please check manually."
    exit 1
  fi
fi

echo "👍 All the files are valid."
exit 0
