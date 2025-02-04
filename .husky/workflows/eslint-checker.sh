#!/bin/bash
# Get staged JS/TS files
STAGED_FILES=$(git --no-pager diff --cached --name-only --diff-filter=AMCR | grep -E '\.(js|ts|tsx|jsx)$' || true)

# Exit if no JS/TS files are staged
if [ -z "$STAGED_FILES" ]; then
  echo "👍 No staged JS/TS files to lint."
  exit 0
fi

# Run check ESLint rules on staged files
npx eslint $STAGED_FILES

# If have errors 
if [ $? -ne 0 ]; then
  read -p "> Run autofix issues? (y/n): " CHOICE

  if [ "$CHOICE" = "y" ]; then
    echo "🛠️ Fixing ESLint issues in staged files..."
    npx eslint --fix $STAGED_FILES

    # Issues can't be autofixed by ESLint
    if [[ $? -ne 0 ]]; then
        echo "❌ Please fix the issues before commit."
        exit 1
    else
        echo "👍 Git add files to Git..."
        git add $STAGED_FILES
        echo "📌 Files added successfully."
    fi
  else
    echo "❌ Please fix the issues before commit."
    exit 1
  fi 
fi

echo "👍 All the files are valid."
exit 0