# php.sh

```bash
#!/bin/bash
skelphp(){
cat > info.php << 'EOF'
<?php phpinfo();

EOF
}
skelref(){
cat > info.php << 'EOF'
<?php
class View extends Views{}

EOF
}
```
