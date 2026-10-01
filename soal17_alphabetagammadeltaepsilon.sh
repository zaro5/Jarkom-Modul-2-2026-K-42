for client in alpha beta gamma delta epsilon; do
    echo "=== Query ${client} ==="
    dig TXT ${client}.k42.com +short
done