# cmake.sh

```bash
#!/bin/bash
skelcmake(){
OUTPUT=CMakeLists.txt
if [ ! -f "$OUTPUT" ]; then
cat << 'EOF' > $OUTPUT
cmake_minimum_required(VERSION 2.8.12.2)
project(skel CXX)
add_executable(skelton main.cpp)

EOF
fi
}
```
