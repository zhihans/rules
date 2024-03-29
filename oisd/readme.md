```yaml
rule-providers:
  oisd:
    type: http
    format: text    
    behavior: classical
    # path: ./oisd.text
    url: "https://raw.githubusercontent.com/zhihans/clash-rules/main/oisd/oisd_small_abp.txt"
    interval: 600
```
