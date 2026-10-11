# sshtestbitbucket.sh

```bash
#!/bin/bash
sshtestbitbucket(){
  echo "SSH TEST BITBUCKET"
  ssh -o "StrictHostKeyChecking=no" -T git@bitbucket.org
}
```
