<?php
$connect = new mysqli("localhost", "root","", "app_news");

if ($connect) {
    //echo "sukses";
}else{
    echo "gagal";
    exit();
}
?>