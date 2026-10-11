# python.sh

```bash
#!/bin/bash
skelpython(){
OUTPUT=main.py
if [ ! -f "$OUTPUT" ]; then
bash -c "cat << 'EOF' > $OUTPUT
#!/usr/bin/env python3
# coding:utf-8

EOF"
chmod +x $OUTPUT
fi
}
```
