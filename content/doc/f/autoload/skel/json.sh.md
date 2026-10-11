# json.sh

```bash
#!/bin/bash
skeljson(){
OUTPUT=skel.json
if [ ! -f "$OUTPUT" ]; then
cat << 'EOF' > $OUTPUT
{
  "root":{
    "id":"1",
    "list":["a","b","c"],
    "object":{"key":"val"},
    "array":[
      {"name":"name1"},
      {"name":"name2"}
    ]
  }
}
EOF
fi
}
```
