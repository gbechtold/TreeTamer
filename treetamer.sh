#!/bin/bash

# 🌳 TreeTamer: A tool to flatten project directory structures
# Version 1.1.0

# Set the source and destination directories
SRC_DIR="."
DEST_DIR="./tamed_tree"

# Default exclusions
DEFAULT_EXCLUDE="node_modules,target,.git,.idea,build,dist,venv,__pycache__"

# Function to display help message
display_help() {
    echo "🌳 TreeTamer: Flatten your project's directory structure"
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  -h, --help        🔍 Display this help message"
    echo "  -c, --clean       🧹 Remove existing destination directory before flattening"
    echo "  -e, --exclude     🚫 Comma-separated list of additional directories to exclude"
    echo "  -i, --include     ✅ Comma-separated list of directories to include (overrides default exclusions)"
    echo "  -f, --filter      🔍 Comma-separated list of file extensions to include"
    echo "  -l, --links       🔗 How to handle symbolic links: 'follow', 'preserve', or 'ignore' (default: ignore)"
    echo
    echo "Default excluded directories: $DEFAULT_EXCLUDE"
    echo
    echo "Example: $0 -c -e logs,temp -i node_modules -f js,py,txt -l preserve"
}

# Parse command-line options
CLEAN=false
EXCLUDE=""
INCLUDE=""
FILTER=""
LINK_HANDLING="ignore"

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            display_help
            exit 0
            ;;
        -c|--clean)
            CLEAN=true
            shift
            ;;
        -e|--exclude)
            EXCLUDE=$2
            shift 2
            ;;
        -i|--include)
            INCLUDE=$2
            shift 2
            ;;
        -f|--filter)
            FILTER=$2
            shift 2
            ;;
        -l|--links)
            LINK_HANDLING=$2
            shift 2
            ;;
        *)
            echo "❌ Unknown option: $1"
            display_help
            exit 1
            ;;
    esac
done

# Clean existing destination directory if requested
if [ "$CLEAN" = true ] && [ -d "$DEST_DIR" ]; then
    echo "🧹 Removing existing tamed tree..."
    rm -rf "$DEST_DIR"
fi

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Prepare find command
FIND_CMD="find \"$SRC_DIR\" -type f ! -name \"$(basename "$0")\" ! -path \"$DEST_DIR/*\""

# Handle exclusions and inclusions
if [ -n "$INCLUDE" ]; then
    # If directories are explicitly included, only use those
    IFS=',' read -ra INCLUDE_ARRAY <<< "$INCLUDE"
    for i in "${INCLUDE_ARRAY[@]}"; do
        FIND_CMD+=" ! -path \"*/$i/*\""
    done
else
    # Use default exclusions and any additional user-specified exclusions
    IFS=',' read -ra EXCLUDE_ARRAY <<< "$DEFAULT_EXCLUDE,$EXCLUDE"
    for i in "${EXCLUDE_ARRAY[@]}"; do
        FIND_CMD+=" ! -path \"*/$i/*\""
    done
fi

# Add file type filter to find command
if [ -n "$FILTER" ]; then
    FIND_CMD+=" \( "
    IFS=',' read -ra FILTER_ARRAY <<< "$FILTER"
    for i in "${FILTER_ARRAY[@]}"; do
        FIND_CMD+=" -name \"*.$i\" -o"
    done
    FIND_CMD="${FIND_CMD% -o} \)"
fi

# Add symbolic link handling to find command
case $LINK_HANDLING in
    follow)
        FIND_CMD+=" -L"
        ;;
    preserve)
        FIND_CMD+=" -P"
        ;;
    ignore)
        FIND_CMD+=" ! -type l"
        ;;
    *)
        echo "⚠️  Invalid link handling option. Using 'ignore'."
        FIND_CMD+=" ! -type l"
        ;;
esac

# Function to generate a unique filename
generate_unique_filename() {
    local base_name=$1
    local extension="${base_name##*.}"
    local name="${base_name%.*}"
    local counter=1
    local new_name="$base_name"

    while [[ -e "$DEST_DIR/$new_name" ]]; do
        new_name="${name}_${counter}.${extension}"
        ((counter++))
    done

    echo "$new_name"
}

# Process files
total_files=$(eval "$FIND_CMD" | wc -l)
processed_files=0

echo "🌳 TreeTamer is working its magic..."

eval "$FIND_CMD" -print0 | while IFS= read -r -d '' file; do
    # Get the relative path of the file
    rel_path="${file#$SRC_DIR/}"
    
    # Replace directory separators with hyphens
    new_name=$(echo "$rel_path" | sed 's/\//-/g')
    
    # Handle filename collisions
    new_name=$(generate_unique_filename "$new_name")
    
    # Copy the file to the destination directory with the new name
    rsync -a "$file" "$DEST_DIR/$new_name"
    
    # Update progress
    ((processed_files++))
    progress=$((processed_files * 100 / total_files))
    printf "\r🚀 Progress: [%-50s] %d%%" $(printf "#%.0s" $(seq 1 $((progress / 2)))) "$progress"
done

echo -e "\n✅ TreeTamer has successfully flattened your project into $DEST_DIR"

# Generate a tree structure of the original project
tree -L 3 -I "tamed_tree|.git" > "$DEST_DIR/original_structure.txt"

echo "📊 Original project structure saved to $DEST_DIR/original_structure.txt"
echo "🎉 All done! Your wild directory tree has been tamed!"
