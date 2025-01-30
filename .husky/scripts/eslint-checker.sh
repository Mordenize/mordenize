#!/bin/bash
# Run the script with an interactive terminal
exec < /dev/tty

# Keep ESLint's color output in a Husky pre-commit hook 
export FORCE_COLOR=1

# Get staged JS and TS files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=d | grep -E '\.(js|ts)$' || true)

# Exit if no JS/TS files are staged
if [ -z "$STAGED_FILES" ]; then
  echo "No staged JS/TS files to lint."
  exit 0
fi

# Run check ESLint rules on staged files
ESLINT_OUTPUT=$(npx eslint $STAGED_FILES || true)

if [ -n "$ESLINT_OUTPUT" ]; then
  echo "$ESLINT_OUTPUT"
  read -p "> Fix issues? (y/n): " CHOICE

  if [ "$CHOICE" = "y" ]; then
    echo "🛠️ Fixing ESLint issues in staged files..."
    npx eslint --fix $STAGED_FILES

    echo "✅ ESLint fixes applied. Re-adding files to Git..."
    git add $STAGED_FILES
    echo "📌 Files re-added successfully."
  else
    echo "❌ ESLint encountered errors. Please check manually."
    exit 1
  fi
fi

exit 0
