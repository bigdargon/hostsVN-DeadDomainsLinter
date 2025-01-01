#!/bin/bash

# Khai báo các URL và tên tệp đích
declare -A FILES=(
    ["https://raw.githubusercontent.com/bigdargon/hostsVN/master/hosts"]="hostsVN.txt"
    ["https://raw.githubusercontent.com/bigdargon/hostsVN/refs/heads/master/extensions/adult/hosts"]="adult.txt"
    ["https://raw.githubusercontent.com/bigdargon/hostsVN/refs/heads/master/extensions/gambling/hosts"]="gambling.txt"
    ["https://raw.githubusercontent.com/bigdargon/hostsVN/refs/heads/master/extensions/threat/hosts"]="threat.txt"
)

# Lặp qua các URL, tải tệp và xử lý
for URL in "${!FILES[@]}"; do
    OUTPUT_FILE=${FILES[$URL]}
    echo "Đang tải tệp từ $URL..."
    curl -s "$URL" | grep -v '^#' | sed -E 's/^0\.0\.0\.0[[:space:]]+(.+)/||\1^/' > "$OUTPUT_FILE"

    if [ $? -eq 0 ]; then
        echo "Tệp '$OUTPUT_FILE' đã được tải và xử lý thành công."
    else
        echo "Tải hoặc xử lý tệp từ $URL thất bại. Vui lòng kiểm tra URL hoặc kết nối mạng."
        exit 1
    fi
done
