# PHP

## Reference

* [PHP](https://www.php.net/docs.php)

### HelloWorld

```php
<?php
//index.php
echo 'HelloWorld';
?>
```

### 配列から多次元連想配列を作成（ワンライナー）

```php
$arr=array_map(fn($v)=>['v'=>$v],$arr);
////or
array_walk($arr,fn(&$v,$k)=>$v=['v'=>$v]);
```

### 配列から条件に合うものを抽出（ワンライナー）

```php
$arr=array_filter($arr,fn($v)=>$v==='MATCH');
```

### 配列から(条件に合う要素で)多次元連想配列を作成

array_walkよりforeachの方が分かりやすく速い

```php
foreach ($arr as $k=>$v) {
	if(true){
		$arr[$k]=['v'=>$v];
	}else{
		unset($arr[$k]);
	}
}
////or
array_walk($arr,function($v,$k)use(&$arr){
	if(true){
		$arr[$k]=['v'=>$v];
	}else{
		unset($arr[$k]);
	}
});
```

## Laravel(v8.54)
```bash
composer.phar create-project --prefer-dist laravel/laravel lrvl
##chown ...
sudo chmod -R go+w lrvl/storage/
sudo chmod 777 lrvl/storage/framework/views/
sudo find lrvl/*/     -type d -exec sudo chmod 775 {} +
sudo find lrvl/app/*/ -type f -exec sudo chmod 666 {} +
```

## CakePHP(v4.2.9)

```bash
composer.phar create-project --prefer-dist cakephp/app cake
##chown ...
chmod -R go+w tmp/ logs/
```
