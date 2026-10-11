# sshtestgithub.sh

```bash
#!/bin/bash
sshtestgithub(){
  echo "SSH TEST GITHUB"
  ssh -o "StrictHostKeyChecking=no" -T git@github.com
}
```
