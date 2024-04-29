#!/bin/bash

# 腳本使用说明
usage() {
    echo "Usage: $0 -i <source_directory> -o <output_directory>"
    exit 1
}

# 檢查 7z 或 7zz 是否安裝，並選擇使用的命令
if command -v 7z &>/dev/null; then
    unzip_command="7z"
elif command -v 7zz &>/dev/null; then
    unzip_command="7zz"
else
    echo "Neither 7z nor 7zz is installed. Please install one of them before running this script."
    exit 1
fi

# 解析命令行選項
OPTS=$(getopt i:o: "$@")
if [ $? != 0 ]; then
    echo "Failed parsing options." >&2
    exit 1
fi

# 注意引用以處理空格和特殊字符
eval set -- "$OPTS"

# 提取選項和其參數
while true; do
    case "$1" in
    -i)
        input_directory="$2"
        shift 2
        ;;
    -o)
        output_directory="$2"
        shift 2
        ;;
    --)
        shift
        break
        ;;
    *)
        usage
        ;;
    esac
done

# 檢查是否有設定輸入和輸出目錄
if [ -z "$input_directory" ] || [ -z "$output_directory" ]; then
    usage
fi

echo "Input directory: $input_directory"
echo "Output directory: $output_directory"

# 創建輸出目錄
mkdir -p "$output_directory"

# 查找並解壓所有 .zip 或 .tgz 文件
find "$input_directory" \( -name '*.tgz' -o -name '*.zip' \) -exec "$unzip_command" x "{}" -o"$output_directory" \;

echo "All files have been extracted to $output_directory."
