# Akaima.txt 更新
mkdir -p tmp && cd tmp
curl -L -O https://techdocs.akamai.com/property-manager/pdfs/akamai_ipv4_ipv6_CIDRs-txt.zip -A chrome
unzip *.zip || { echo "Akaima zip 下载失败，脚本退出"; exit 1; }
cat akamai_ipv4_CIDRs.txt | sort -u > ../Akaima.txt
cat akamai_ipv6_CIDRs.txt | sort -u >> ../Akaima.txt
cd ..
rm tmp -r