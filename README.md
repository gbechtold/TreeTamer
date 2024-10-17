# 🌳 TreeTamer

TreeTamer is a powerful bash script that flattens your project's directory structure, making it easier to manage and navigate complex project hierarchies. Tame your wild directory trees with ease! 🐯

## ✨ Features

- 📁 Flattens directory structures while preserving all files
- 🔄 Handles filename collisions
- 🚫 Excludes common directories by default (customizable)
- 🔍 Filters files by extension
- 🔗 Configurable symbolic link handling
- 📊 Progress indication
- 🌲 Generates a tree structure of the original project

## ✨ Quickinstall

```bash
curl -O https://raw.githubusercontent.com/gbechtold/TreeTamer/main/treetamer.sh
```

## 🚀 Usage

```bash
./treetamer.sh [OPTIONS]
```

### 🔧 Options

- `-h, --help`: 🔍 Display the help message
- `-c, --clean`: 🧹 Remove existing destination directory before flattening
- `-e, --exclude`: 🚫 Comma-separated list of additional directories to exclude
- `-i, --include`: ✅ Comma-separated list of directories to include (overrides default exclusions)
- `-f, --filter`: 🔍 Comma-separated list of file extensions to include
- `-l, --links`: 🔗 How to handle symbolic links: 'follow', 'preserve', or 'ignore' (default: ignore)

### 📝 Example

```bash
./treetamer.sh -c -e logs,temp -i node_modules -f js,py,txt -l preserve
```

This command will:
- 🧹 Clean the existing tamed tree directory
- 🚫 Exclude 'logs' and 'temp' directories (in addition to default exclusions)
- ✅ Include 'node_modules' directory (overriding its default exclusion)
- 🔍 Only include .js, .py, and .txt files
- 🔗 Preserve symbolic links

### 🚫 Default Exclusions

By default, TreeTamer excludes the following directories:

`node_modules, target, .git, .idea, build, dist, venv, __pycache__`

You can override these exclusions using the `-i, --include` option.

## 📥 Installation

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/TreeTamer.git
   ```
2. Make the script executable:
   ```
   chmod +x treetamer.sh
   ```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. 🎉

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 📜
