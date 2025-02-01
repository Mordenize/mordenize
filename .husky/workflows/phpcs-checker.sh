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
PHPCS_OUTPUT=$("$VENDOR_BIN_PATH/phpcs" $STAGED_FILES "--standard=./phpcs.xml")
PHPCS_STATUS=$?

echo "$PHPCS_OUTPUT"
# If have errors can be autofixed by PHPCBF
if [ $PHPCS_STATUS -eq 2 ]; then
  read -p "> Fix issues? (y/n): " CHOICE

  if [ "$CHOICE" = "y" ]; then
    # Run autofix PHP files by PHPCBF
    echo "🛠️ Fixing PHP issues in staged files..."
    PHPCBF_OUTPUT=$("$VENDOR_BIN_PATH/phpcbf" $STAGED_FILES)

    # Re-check PHPCS status
    PHPCS_OUTPUT=$("$VENDOR_BIN_PATH/phpcs" $STAGED_FILES "--standard=./phpcs.xml")

    # if have errors can't autofixed by PHPCBF
    if [ $? -eq 1 ]; then
      echo "❗Some errors can't be autofixed by PHPCBF."     
      echo "$PHPCS_OUTPUT"
    fi

    echo "👍 PHPCBF fixes applied. Re-adding files to Git..."
    git add $STAGED_FILES
    echo "📌 Files re-added successfully."
  else
    echo "❌ PHPCS encountered errors. Please check manually."
    exit 1
  fi
fi

echo "👍 All the files are valid."
exit 0