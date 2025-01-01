#!/bin/bash

# Khai báo các URL và tên tệp đích
declare -A FILES=(
    ["https://raw.githubusercontent.com/bigdargon/hostsVN/master/hosts"]="hostsVN.txt"
    ["https://raw.githubusercontent.com/bigdargon/hostsVN/refs/heads/master/extensions/adult/hosts"]="adult.txt"
    ["https://raw.githubusercontent.com/bigdargon/hostsVN/refs/heads/master/extensions/gambling/hosts"]="gambling.txt"
    ["https://raw.githubusercontent.com/bigdargon/hostsVN/refs/heads/master/extensions/threat/hosts"]="threat.txt"
)

# Lặp qua các URL và tải tệp
for URL in "${!FILES[@]}"; do
    OUTPUT_FILE=${FILES[$URL]}
    echo "Đang tải tệp từ $URL..."
    curl -o "$OUTPUT_FILE" "$URL"

    if [ $? -eq 0 ]; then
        echo "Tệp đã được tải thành công và lưu dưới tên '$OUTPUT_FILE'."
    else
        echo "Tải tệp từ $URL thất bại. Vui lòng kiểm tra URL hoặc kết nối mạng."
        exit 1
    fi
done
