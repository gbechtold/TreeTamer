# 🌳 TreeTamer

TreeTamer is a powerful bash script that flattens your project's directory structure, making it easier to manage and navigate complex project hierarchies. Tame your wild directory trees with ease! 🐯

## ✨ Features

- 📁 Flattens directory structures while preserving all files
- 🔄 Handles filename collisions
- 🚫 Excludes specified directories
- 🔍 Filters files by extension
- 🔗 Configurable symbolic link handling
- 📊 Progress indication
- 🌲 Generates a tree structure of the original project

## 🚀 Usage

```bash
./treetamer.sh [OPTIONS]
```

### 🔧 Options

- `-h, --help`: Display the help message
- `-c, --clean`: Remove existing destination directory before flattening
- `-e, --exclude`: Comma-separated list of directories to exclude
- `-f, --filter`: Comma-separated list of file extensions to include
- `-l, --links`: How to handle symbolic links: 'follow', 'preserve', or 'ignore' (default: ignore)

### 📝 Example

```bash
./treetamer.sh -c -e node_modules,target -f js,py,txt -l preserve
```

This command will:
- 🧹 Clean the existing tamed tree directory
- 🚫 Exclude 'node_modules' and 'target' directories
- ✅ Only include .js, .py, and .txt files
- 🔗 Preserve symbolic links

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
