# Bash Scripting Guide

This document covers best practices for writing bash scripts in this repository.

## 1. Always use strict mode

```bash
set -euo pipefail
```
- `-e`: Exit immediately if a command exits with a non-zero status.
- `-u`: Treat unset variables as an error.
- `-o pipefail`: Return value of a pipeline is the status of the last command to exit with a non-zero status.

## 2. Use our utils.sh

Always source `utils.sh` to keep the UI consistent:
```bash
source ./utils.sh
```

Available functions:
- `success "Message"`
- `print_info "Message"`
- `warning "Message"`
- `error "Message"`
- `check_command "gcloud"`
- `check_login`
