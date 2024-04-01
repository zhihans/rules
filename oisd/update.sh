mkdir -p original yaml
curl -L https://small.oisd.nl -o original/oisd_small_abp.txt
curl -L https://big.oisd.nl -o original/oisd_big_abp.txt
curl -L https://nsfw.oisd.nl -o original/oisd_nsfw_abp.txt

for file in original/*; do
    # 处理并写入text yaml
    filename=$(basename "$file")
    yaml_file="yaml/${filename%.*}.yaml"
    echo -n "" > $filename && cat $file >> $filename
    echo "payload:" > $yaml_file && cat $file >> $yaml_file

    sed -i 's/||\(.*\)\^/DOMAIN-SUFFIX,\1/' $filename
    sed -i 's/\[\(.*\)\]/# \1/' $filename
    sed -i 's/^! /# /' $filename

    sed -i 's/||\(.*\)\^/  - DOMAIN-SUFFIX,\1/' $yaml_file
    sed -i 's/\[\(.*\)\]/# \1/' $yaml_file
    sed -i 's/^! /# /' $yaml_file
    sed -i -e '/^#/d' -e '/^$/d' $yaml_file

    # 统计数量 并写入readme
    entries=$(grep -oE '# Entries: [0-9]+' "$filename" | cut -d' ' -f3)
    sed -i "s/$filename | [0-9]\+ |$/$filename | $entries |/" readme.md
done

mkdir -p srs
for file in *.txt; do
  jq -R 'select(test("^DOMAIN-SUFFIX")) | split(",")[1]' $file | jq -s '{ "version": 1, "rules": [{ "domain_suffix": . }] }' > "srs/${file%.txt}.json"
  sing-box rule-set compile srs/${file%.txt}.json
  echo "$file ==>> srs/${file%.txt}.srs"
  rm srs/${file%.txt}.json
done