#!/bin/bash

# 檢查是否有提供目錄參數
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# 讀取第一個參數作為目錄路徑
directory=$1

# 使用 exiftool 掃描指定目錄中的所有檔案
find "$directory" -type f | while read file; do
    # 獲取檔案的 MIME 類型
    mimetype=$(exiftool -b -MimeType "$file")

    # 根據 MIME 類型決定正確的副檔名
    case $mimetype in
        image/jpeg)
            extension="jpg"
            ;;
        image/png)
            extension="png"
            ;;
        image/gif)
            extension="gif"
            ;;
        *)
            extension=""
            ;;
    esac

    # 如果推導出的副檔名不為空，且當前副檔名不正確，則更改之
    if [[ ! -z $extension ]] && [[ ! $file == *.$extension ]]; then
        newfile="${file%.*}.$extension"
        echo "Renaming $file to $newfile"
        mv "$file" "$newfile"
    fi
done
