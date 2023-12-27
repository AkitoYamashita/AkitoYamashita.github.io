# HTML

## 枠線付きのテーブルにするやつ

```html
<table border="1" style="display:inline-block;border-collapse: collapse;">
```

## Minimal Bootstrap CSS

```css
.bs-callout{padding:20px;margin:20px 0;border:1px solid #eee;border-left-width:5px;border-radius:3px}
.bs-callout h4{margin-top:0;margin-bottom:5px}
.bs-callout p:last-child{margin-bottom:0}
.bs-callout code{border-radius:3px}
.bs-callout+.bs-callout{margin-top:-5px}
.bs-callout-danger{border-left-color:#d9534f}
.bs-callout-danger h4{color:#d9534f}
.bs-callout-warning{border-left-color:#f0ad4e}
.bs-callout-warning h4{color:#f0ad4e}
.bs-callout-info{border-left-color:#5bc0de}
.bs-callout-info h4{color:#5bc0de}
```
