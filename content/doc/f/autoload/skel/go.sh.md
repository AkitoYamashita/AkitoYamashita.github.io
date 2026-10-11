# go.sh

```bash
#!/bin/bash
skelgo(){
cat > main.go << 'EOF'
package main
//import (
//	_ "github.com/mattn/go-sqlite3"
//)
import (
	"fmt"
	"os"
	"path/filepath"
)
func main() {
	//fmt.Println("HelloWorld")
	pwd, _ := os.Getwd()
	fmt.Println("PWD:"+pwd)
	exe_path, _ := os.Executable()
	fmt.Println("EXE_PATH:"+exe_path)
	exe_dir := filepath.Dir(exe_path)
	fmt.Println("EXE_DIR:"+exe_dir)
	file, _ := os.Create(exe_dir+"/ok.txt")
	defer file.Close()
	file.Write(([]byte)("Hello,World!"))
}

EOF
}
```
