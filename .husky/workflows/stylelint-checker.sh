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
npx stylelint $STAGED_FILES 2>&1

# If have errors 
if [ $? -ne 0 ]; then
  read -p "> Run autofix issues? (y/n): " CHOICE

  if [ "$CHOICE" = "y" ]; then
    echo "🛠️ Fixing Stylelint issues in staged files..."
    npx stylelint --fix $STAGED_FILES 2>&1

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
    echo "❌ Stylelint encountered errors. Please check manually."
    exit 1
  fi
fi

echo "👍 All the files are valid."
exit 0
