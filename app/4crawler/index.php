<?php
if(!$_GET['url']) $_GET['url'] = 'index';

$cached_file = 'cached-html/'.$_GET['url'].'.html';
if(file_exists($cached_file)) die(file_get_contents($cached_file));
else{
	header("Status: 404 Not Found");
}
?>