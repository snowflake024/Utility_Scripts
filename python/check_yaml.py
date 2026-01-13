check_yaml() {
    python3 -c "
import sys
import yaml
try:
    with open('$1') as f:
        yaml.safe_load(f)
    print('YAML OK: $1')
except Exception as e:
    print('YAML ERROR in \$1:', e)
    exit(1)
"
}

# USAGE:
#  check_yaml <FILE_PATH>
