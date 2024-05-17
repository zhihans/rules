import sys
import os
import yaml
import json

def transform_rules(initial_rules):
    transformed_rules = {
        "version": 1,
        "rules": [{}]
    }

    for rule in initial_rules.get("payload", []):
        rule_type, rule_value = rule.split(",", 1)
        if rule_type == "DOMAIN-SUFFIX":
            transformed_rules["rules"][0]["domain_suffix"] = transformed_rules["rules"][0].get("domain_suffix", []) + [rule_value]
        elif rule_type == "DOMAIN-KEYWORD":
            transformed_rules["rules"][0]["domain_keyword"] = transformed_rules["rules"][0].get("domain_keyword", []) + [rule_value]
        elif rule_type == "DOMAIN-REGEX":
            transformed_rules["rules"][0]["domain_regex"] = transformed_rules["rules"][0].get("domain_regex", []) + [rule_value]
        elif rule_type.startswith("DOMAIN"):
            transformed_rules["rules"][0]["domain"] = transformed_rules["rules"][0].get("domain", []) + [rule_value]
        else:
            print(f"Unsupported rule type: {rule_type}")

    return transformed_rules


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python transfo.py <input_yaml_file1> <input_yaml_file2> ...")
        sys.exit(1)

    input_files = sys.argv[1:]
    for input_file_path in input_files:
        if not os.path.isfile(input_file_path):
            print(f"File not found: {input_file_path}")
            continue

        output_file_path = os.path.splitext(input_file_path)[0] + ".json"
        with open(input_file_path, 'r') as file:
            initial_rules = yaml.safe_load(file)
        transformed_rules = transform_rules(initial_rules)
        with open(output_file_path, 'w') as file:
            json.dump(transformed_rules, file, indent=2, sort_keys=True)

        print(f"Transformation complete for {input_file_path}. JSON file written to {output_file_path}")
