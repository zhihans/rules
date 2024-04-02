| 文件名 | 条目数 |
| ------- | ------ |
| oisd_big_abp.txt | 193617 |
| oisd_nsfw_abp.txt | 402438 |
| oisd_small_abp.txt | 45532 |

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

```yaml
rule-providers:
  oisd:
    type: http
    format: yaml
    behavior: classical
    # path: ./oisd.yaml
    url: "https://raw.githubusercontent.com/zhihans/clash-rules/main/oisd/yaml/oisd_small_abp.yaml"
    interval: 600
```