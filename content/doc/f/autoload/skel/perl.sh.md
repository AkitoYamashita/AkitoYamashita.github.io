# perl.sh

```bash
#!/bin/bash
skelperl(){
OUTPUT=skel.pl
if [ ! -f "$OUTPUT" ]; then
cat << 'EOF' > $OUTPUT
#!/usr/bin/perl
print "Content-type: text/html\n\n";
print "HelloWorld\n";

EOF
chmod 755 $OUTPUT
fi
}
```
