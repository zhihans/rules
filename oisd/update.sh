curl -s -L https://small.oisd.nl -o small.abp
# curl -s -L https://big.oisd.nl -o big.abp
# curl -s -L https://nsfw.oisd.nl -o nsfw.abp

for file in *.abp; do
    filename=$(basename "$file")
    txt_file="${filename%.*}.txt"
    yaml_file="${filename%.*}.yaml"
    srs_file="${filename%.*}.srs"
    json_file="${filename%.*}.json"

    # abp ==>> txt
    cp $filename  $txt_file
    sed -i 's/||\(.*\)\^/\1/' $txt_file
    sed -i 's/\[\(.*\)\]/# \1/' $txt_file
    sed -i 's/^! /# /' $txt_file
    sed -i -e '/^#/d' -e '/^$/d' $txt_file

    # abp ==>> yaml
    echo "payload:" > $yaml_file && cat $file >> $yaml_file
    sed -i 's/||\(.*\)\^/  - DOMAIN-SUFFIX,\1/' $yaml_file
    sed -i 's/\[\(.*\)\]/# \1/' $yaml_file
    sed -i 's/^! /# /' $yaml_file
    sed -i -e '/^#/d' -e '/^$/d' $yaml_file

    # yaml ==>> json srs
    jq -R 'select(test("^  - DOMAIN-SUFFIX")) | split(",")[1]' $yaml_file | jq -s '{ "version": 1, "rules": [{ "domain_suffix": . }] }' > $json_file
    sing-box rule-set compile $json_file
done
