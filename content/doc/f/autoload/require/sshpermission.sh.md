# sshpermission.sh

```bash
#!/bin/bash
sshpermission(){
  sudo find -L ~/.ssh/ -type d -exec sudo chmod 755 {} +
  sudo find -L ~/.ssh/ -type f -exec sudo chmod 600 {} +
}
```
