# golang

## テンプレート(パス)

```go
package main
//import (
//    "github.com/mattn/go-sqlite3"
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
```

## UDPクライアント

```golang
package main
import (
    "fmt"
    "net"
    "bufio"
)
func main() {
    p :=  make([]byte, 2048)
    conn, err := net.Dial("udp", "192.168.128.113:22222")
    if err != nil {
        fmt.Printf("Some error %v", err)
        return
    }
    fmt.Fprintf(conn, "Hi UDP Server, How are you doing?")
    _, err = bufio.NewReader(conn).Read(p)
    if err == nil {
        fmt.Printf("%s\n", p)
    } else {
        fmt.Printf("Some error %v\n", err)
    }
    conn.Close()
}
```

## UDPサーバー

```golang
package main

import (
    "log"
    "net"
    "os"
)

func main() {
    udpAddr := &net.UDPAddr{
        IP:   net.ParseIP("0.0.0.0"),
        Port: 22222,
    }
    updLn, err := net.ListenUDP("udp", udpAddr)
    if err != nil {
        log.Fatalln(err)
        os.Exit(1)
    }
    buf := make([]byte, 1024)
    log.Println("Starting udp server...")
    for {
        n, addr, err := updLn.ReadFromUDP(buf)
        if err != nil {
            log.Fatalln(err)
            os.Exit(1)
        }
        go func() {
            log.Printf("Reciving data: %s from %s", string(buf[:n]), addr.String())

            log.Printf("Sending data..")
            updLn.WriteTo([]byte("Pong"), addr)
            log.Printf("Complete Sending data..")
        }()
    }
}
```
