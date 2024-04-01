#!/bin/bash

CONFIG_FILE="config.json"
TEMPLATE_DIR="CharacterPackTemplate"
ASSETS_DIR="assets"
TARGET_DIR=".."

# Ensure jq is available
if ! command -v jq &> /dev/null; then
    echo "jq could not be found, please install jq to proceed."
    exit 1
fi

for MOD_NAME in $(jq -r 'keys[]' $CONFIG_FILE); do
    CALL_SIGN=$(jq -r ".${MOD_NAME}.call_sign" $CONFIG_FILE)
    UNITS=$(jq -r ".${MOD_NAME}.units[]" $CONFIG_FILE | tr '\n' ',' | sed 's/,$//')

    jq -r '.["'"$MOD_NAME"'"]' $CONFIG_FILE

    # Define the target mod directory
    MOD_TARGET_DIR="$TARGET_DIR/Character-Pack-$MOD_NAME"

    # Recreate mod directory and copy template
    rm -rf "$MOD_TARGET_DIR"
    mkdir -p "$MOD_TARGET_DIR"
    cp -r $TEMPLATE_DIR/* "$MOD_TARGET_DIR/"

    # Step 2: Copy images and description for the mods
    if [ -d "$ASSETS_DIR/$MOD_NAME/" ]; then
        cp -r "$ASSETS_DIR/$MOD_NAME/"* "$MOD_TARGET_DIR/"
    else
        echo "No assets found for $MOD_NAME, skipping asset copy."
    fi

    # Step 3: Replace call sign in Utilities.lua
    TARGET_FILE="${MOD_TARGET_DIR}/Utilities.lua"

    # Check if the target file exists
    if [ -f "$TARGET_FILE" ]; then
        {
            echo ""
            echo "function modSign(mode)"
            echo "    if mode == 0 then"
            echo "        return \"$CALL_SIGN\""
            echo "    elseif mode == 1 then"
            echo "        return {"
            echo "$UNITS" | sed 's/,/, /g' | sed 's/^/            "/; s/$/",/'
            echo "        }"
            echo "    end"
            echo ""
            echo '    error("Invalid mode: " .. tostring(mode))'
            echo "end"
        } >> "$TARGET_FILE"
    else
        echo "Target file ${TARGET_FILE} not found."
    fi

    echo "Setup done for $MOD_TARGET_DIR".
done
echo "Setup complete".