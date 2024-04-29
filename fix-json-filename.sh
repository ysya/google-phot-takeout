#!/bin/bash

# 他輸出的時候會亂命名，所以我們要把他們改回來
# 如原檔為：file(1).jpg，Google會把它變成file.jpg(1).json

# 檢查是否有提供目錄參數
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# 讀取第一個參數作為目錄路徑
directory=$1

# 刪除隱藏檔

# 遍歷指定目錄及其所有子目錄下的.json檔案
find "$directory" -type f -name '*.json' | while read f; do
    # 檢查檔案名是否符合特定模式
    if [[ "$f" =~ (.*)\.(.*)\((.*)\)\.json ]]; then
        # 提取檔案名、擴展名和括號內的數字
        base_name="${BASH_REMATCH[1]}"
        extension="${BASH_REMATCH[2]}"
        number="${BASH_REMATCH[3]}"

        # 生成新的檔案名
        new_name="${base_name}(${number}).${extension}.json"

        # 重命名檔案
        echo "Renaming '$f' to '$new_name'"
        mv "$f" "$new_name"
    fi
done

find "$directory" -name ".*" -type f -delete
