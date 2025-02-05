#!/bin/bash
# Get staged PHP files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=AMCR | grep -E '\.(php)$' || true)

# Exit if no PHP files are staged
if [ -z "$STAGED_FILES" ]; then
  echo "👍 No staged PHP files to lint."
  exit 0
fi

# Config path & command
VENDOR_BIN_PATH=./vendor/bin

# If your bash version is 3.x, you'll need to update it because readarray doesn't support from this version
FILES=()
while IFS= read -r file; do
  FILES+=("$file")
done <<< "$STAGED_FILES"
"$VENDOR_BIN_PATH/phpcs" -s --standard=./phpcs.xml "${FILES[@]}"

# If have errors
if [ $? -ne 0 ]; then
  read -p "> Run autofix issues? (y/n): " CHOICE

  if [ "$CHOICE" = "y" ]; then
    # Run autofix PHP files by PHPCBF
    echo "🛠️ Fixing PHP issues in staged files..."
    "$VENDOR_BIN_PATH/phpcbf" -s --standard=./phpcs.xml "${FILES[@]}" > /dev/null 2>&1

    echo "🛠️ Re-check PHPCS after autofix"
    "$VENDOR_BIN_PATH/phpcs" -s --standard=./phpcs.xml "${FILES[@]}"

    # after run PHPCBF still have errors can't autofixed
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