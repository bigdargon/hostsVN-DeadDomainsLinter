#!/bin/bash

# Khai báo các URL và tên tệp đích
declare -A FILES=(
    ["https://raw.githubusercontent.com/bigdargon/hostsVN/refs/heads/master/hosts"]="hostsVN.txt"
    ["https://raw.githubusercontent.com/bigdargon/hostsVN/refs/heads/master/extensions/adult/hosts"]="adult.txt"
    ["https://raw.githubusercontent.com/bigdargon/hostsVN/refs/heads/master/extensions/gambling/hosts"]="gambling.txt"
    ["https://raw.githubusercontent.com/bigdargon/hostsVN/refs/heads/master/extensions/threat/hosts"]="threat.txt"
)

# Lặp qua các URL, tải tệp và xử lý
for URL in "${!FILES[@]}"; do
    OUTPUT_FILE=${FILES[$URL]}
    echo "Đang kiểm tra phiên bản cho $OUTPUT_FILE..."

    # Kiểm tra phiên bản trên máy chủ
    SERVER_VERSION=$(curl -s "$URL" | grep '^# Version:')

    if [ $? -ne 0 ] || [ -z "$SERVER_VERSION" ]; then
        echo "Không thể lấy phiên bản từ $URL. Vui lòng kiểm tra kết nối mạng hoặc URL."
        exit 1
    fi

    # Kiểm tra phiên bản trên local
    if [ -f "$OUTPUT_FILE" ]; then
        LOCAL_VERSION=$(grep '^# Version:' "$OUTPUT_FILE" || echo "")
    else
        LOCAL_VERSION=""
    fi

    # So sánh phiên bản
    if [ "$SERVER_VERSION" == "$LOCAL_VERSION" ]; then
        echo "Tệp '$OUTPUT_FILE' không có thay đổi."
        continue
    fi

    # Tải và xử lý tệp nếu phiên bản khác nhau
    echo "Đang tải tệp từ $URL..."
    CONTENT=$(curl -s "$URL")
    if [ $? -ne 0 ]; then
        echo "Tải tệp từ $URL thất bại. Vui lòng kiểm tra kết nối mạng."
        exit 1
    fi

    # Ghi dòng version vào đầu tệp
    echo "$SERVER_VERSION" > "$OUTPUT_FILE"

    # Lọc nội dung không cần thiết và ghi tiếp vào tệp
    echo "$CONTENT" | grep -v '^#' | sed -E 's/^0\.0\.0\.0[[:space:]]+(.+)/||\1^/' >> "$OUTPUT_FILE"

    echo "Tệp '$OUTPUT_FILE' đã được cập nhật với phiên bản mới: $SERVER_VERSION."
done
