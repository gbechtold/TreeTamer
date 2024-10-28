#!/bin/bash

# 🌳 TreeTamer: A tool to flatten project directory structures
# Version 1.2.2

# Set the source and destination directories
SRC_DIR="."
DEST_DIR="./tamed_tree"

# Default file extensions to include (projektspezifische Dateien)
DEFAULT_EXTENSIONS=(
    # Code Files
    "js"
    "jsx"
    "ts"
    "tsx"
    "css"
    "scss"
    "less"
    "html"
    "vue"
    "php"
    "py"
    "java"
    "rb"
    "go"
    "rs"
    "sql"
    # Config Files
    "yml"
    "yaml"
)

# Wichtige Projektdateien die immer inkludiert werden sollen
IMPORTANT_PROJECT_FILES=(
    ".gitignore"
    "package.json"
    "README.md"
)

# Wichtige Projektverzeichnisse die immer inkludiert werden sollen
IMPORTANT_PROJECT_DIRS=(
    "src/config/"
    "src/modules/"
)

# Standard-Excludes (nicht projektspezifische Dateien)
EXCLUDE_PATTERNS=(
    # Dependency Verzeichnisse
    "node_modules/"
    "vendor/"
    "bower_components/"
    ".next/"
    "dist/"
    "build/"
    "target/"
    "out/"
    "output/"
    "logs/"
    "coverage/"
    "tmp/"
    "temp/"
    ".sass-cache/"
    "__pycache__/"
    ".pytest_cache/"
    "venv/"
    ".venv/"
    "env/"
    ".env/"
    
    # Version Control (außer .gitignore)
    ".git/"
    ".svn/"
    ".hg/"
    
    # IDE und Editor Dateien
    ".idea/"
    ".vscode/"
    ".vs/"
    "*.swp"
    "*.swo"
    ".DS_Store"
    "Thumbs.db"
    
    # Build Artifacts
    "*.pyc"
    "*.pyo"
    "*.pyd"
    "*.so"
    "*.dll"
    "*.dylib"
    "*.exe"
    "*.obj"
    "*.o"
    
    # Package Manager Dateien (außer package.json)
    "package-lock.json"
    "yarn.lock"
    "composer.lock"
    "Gemfile.lock"
    "poetry.lock"
    "pnpm-lock.yaml"
    
    # Konfigurationsdateien die ignoriert werden sollen
    ".eslintrc*"
    ".prettierrc*"
    ".babelrc*"
    "tsconfig.json"
    "webpack.config.*"
    "rollup.config.*"
    "jest.config.*"
    ".travis.yml"
    ".gitlab-ci.yml"
    "docker-compose*.yml"
    "Dockerfile"
    ".dockerignore"
    ".env*"
    ".editorconfig"
    "browserslist"
    ".browserslistrc"
    "*.config.js"
    "*.conf.js"
    
    # Archive
    "*.zip"
    "*.tar"
    "*.gz"
    "*.rar"
    "*.7z"
    
    # Logs
    "*.log"
    "npm-debug.log*"
    "yarn-debug.log*"
    "yarn-error.log*"
)

# Build the find command
build_find_command() {
    local cmd="find \"$SRC_DIR\" -type f ! -name \"$(basename "$0")\" ! -path \"$DEST_DIR/*\""
    
    # Add exclusion patterns
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        if [[ $pattern == *"/" ]]; then
            cmd+=" ! -path \"*/${pattern}*\""
        else
            cmd+=" ! -name \"$pattern\""
        fi
    done

    # Start conditions for files to include
    cmd+=" \( "
    
    # Add default file extensions
    local first=true
    for ext in "${DEFAULT_EXTENSIONS[@]}"; do
        if [ "$first" = true ]; then
            cmd+=" -name \"*.$ext\""
            first=false
        else
            cmd+=" -o -name \"*.$ext\""
        fi
    done

    # Add important project files
    for file in "${IMPORTANT_PROJECT_FILES[@]}"; do
        cmd+=" -o -name \"$file\""
    done

    # Add important project directories
    for dir in "${IMPORTANT_PROJECT_DIRS[@]}"; do
        cmd+=" -o -path \"*/$dir*\""
    done

    cmd+=" \)"
    
    echo "$cmd"
}

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Build and execute find command
FIND_CMD=$(build_find_command)
echo "🔍 Suche nach projektspezifischen Dateien..."

total_files=$(eval "$FIND_CMD" | wc -l)
if [ "$total_files" -eq 0 ]; then
    echo "⚠️  Keine projektspezifischen Dateien gefunden!"
    exit 0
fi

echo "🌳 Verarbeite $total_files Dateien..."
processed_files=0

eval "$FIND_CMD" -print0 | while IFS= read -r -d '' file; do
    # Get relative path and create new filename
    rel_path="${file#$SRC_DIR/}"
    new_name=$(echo "$rel_path" | sed 's/\//-/g')
    
    # Copy file
    cp "$file" "$DEST_DIR/$new_name"
    
    # Update progress
    ((processed_files++))
    progress=$((processed_files * 100 / total_files))
    printf "\r🚀 Fortschritt: [%-50s] %d%%" $(printf "#%.0s" $(seq 1 $((progress / 2)))) "$progress"
done

echo -e "\n✅ Projekt wurde erfolgreich in $DEST_DIR kopiert"

# Optional: Originale Projektstruktur dokumentieren
if command -v tree &> /dev/null; then
    tree -L 3 -I "tamed_tree|$(echo "${EXCLUDE_PATTERNS[@]}" | tr ' ' '|')" > "$DEST_DIR/original_structure.txt"
    echo "📊 Originale Projektstruktur wurde in $DEST_DIR/original_structure.txt gespeichert"
fi

echo "🎉 Fertig! Projektdateien wurden erfolgreich extrahiert!"
