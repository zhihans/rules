curl -s -L https://small.oisd.nl -o small.txt
# curl -s -L https://big.oisd.nl -o big.txt
# curl -s -L https://nsfw.oisd.nl -o nsfw.txt
echo '```' > readme.md
head -n 12 *.txt >> readme.md
echo '```' >> readme.md
for file in *.txt; do
    filename=$(basename "$file")

    # txt
    sed -e 's/||\(.*\)\^/\1/' \
        -e '/\[\(.*\)\]/d' \
        -e '/^! /d' \
        -e '/^#/d' \
        -e '/^$/d' $filename -i

    # txt ==>> text mrs
    sed 's/^/+./' $filename > ${filename%.*}.text
    mihomo convert-ruleset domain text ${filename%.*}.text ${filename%.*}.mrs

    # txt ==>> json srs
    jq -R 'select(length > 0)' $filename | jq -s '{ "version": 3, "rules": [{ "domain_suffix": . }] }' > ${filename%.*}.json
    sing-box rule-set compile ${filename%.*}.json
done
