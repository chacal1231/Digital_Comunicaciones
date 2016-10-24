<?php
$host = "localhost"; 
$user = "root";
$pass = "123456789"; 
$database ="digital";
$fecha=date("Y-m-d H:i:s");
$link=mysqli_connect($host,$user,$pass,$database); 
$temp=mysqli_real_escape_string($link,$_GET['temp']);
mysqli_query($link,"INSERT INTO datos(temp,tiempo) VALUES('$temp','$fecha')");
?>