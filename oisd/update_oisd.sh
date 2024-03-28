curl -L https://small.oisd.nl -o oisd_small_abp.txt
curl -L https://big.oisd.nl -o oisd_big_abp.txt
curl -L https://nsfw.oisd.nl -o oisd_nsfw_abp.txt
sed -i 's/||\(.*\)\^/DOMAIN-SUFFIX,\1/' *.txt
sed -i 's/\[\(.*\)\]/# \1/' *.txt
sed -i 's/^! /# /' *.txt

