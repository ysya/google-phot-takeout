#!/bin/bash

# 腳本使用说明
usage() {
    echo "Usage: $0 -in <source_directory> -out <output_directory>"
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

# 解析命令行參數
while getopts ":in:out:" opt; do
    case $opt in
    in)
        input_directory=$OPTARG
        ;;
    out)
        output_directory=$OPTARG
        ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        usage
        ;;
    :)
        echo "Option -$OPTARG requires an argument." >&2
        usage
        ;;
    esac
done

# 檢查是否有設定輸入和輸出目錄
if [ -z "$input_directory" ] || [ -z "$output_directory" ]; then
    usage
fi

# 創建輸出目錄
mkdir -p "$output_directory"

# 查找並解壓所有 .zip 或 .tgz 文件
find "$input_directory" \( -name '*.tgz' -o -name '*.zip' \) -exec "$unzip_command" x "{}" -o"$output_directory" \;

echo "All files have been extracted to $output_directory."
