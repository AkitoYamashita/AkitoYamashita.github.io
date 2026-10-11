# cpp.sh

```bash
#!/bin/bash
skelcpp(){
OUTPUT=skel.cpp
if [ ! -f "$OUTPUT" ]; then
cat << 'EOF' > $OUTPUT
#include <iostream>
int main() {
  std::cout << "HelloWorld" << std::endl;
  return 0;
}
EOF
fi
}
```
