<?php
$host = "localhost"; 
$user = "root";
$pass = "123456789"; 
$database ="UNECOHOGAR";
$fecha=date("Y-m-d H:i:s");
$link=mysqli_connect($host,$user,$pass,$database);
$temp=mysqli_real_escape_string($link,$_GET['T']);
$peso=mysqli_real_escape_string($link,$_GET['P']);
$nivel_luz=mysqli_real_escape_string($link,$_GET['N']);
$etapa_c=mysqli_real_escape_string($link,$_GET['E']);
$dete_agu=mysqli_real_escape_string($link,$_GET['D']);
$nivel_ag=mysqli_real_escape_string($link,$_GET['A']);
$potencia=mysqli_real_escape_string($link,$_GET['O']);
$costo_poten=mysqli_real_escape_string($link,$_GET['C']);
$FI=mysqli_real_escape_string($link,$_GET['F']);
$TETA=mysqli_real_escape_string($link,$_GET['H']);
if(!empty($temp)){
        mysqli_query($link,"INSERT INTO temp(temp,fecha) VALUES('$temp','$fecha')");
} 
else if(!empty($peso)){
        mysqli_query($link,"INSERT INTO peso(peso,fecha) VALUES('$peso','$fecha')");
}
else if(!empty($nivel_luz)){
        mysqli_query($link,"INSERT INTO nivel_luz(nivel,fecha) VALUES('$nivel_luz','$fecha')");
}
else if(!empty($etapa_c)){
        mysqli_query($link,"INSERT INTO etapa_cre(etapa,fecha) VALUES('$etapa_c','$fecha')");
}
else if(!empty($dete_agu)){
        mysqli_query($link,"INSERT INTO detector_a(detec,fecha) VALUES('$dete_agu','$fecha')");
}
else if(!empty($nivel_ag)){
        mysqli_query($link,"INSERT INTO nivel_agu(nivel,fecha) VALUES('$nivel_ag','$fecha')");
}
else if(!empty($potencia)){
		mysqli_query($link,"INSERT INTO potencia(potencia,fecha) VALUES('$potencia','$fecha')");
}
else if(!empty($costo_poten)){
        mysqli_query($link,"INSERT INTO costo_p(costo,fecha) VALUES('$costo_poten','$fecha')");
}
else if(!empty($FI)){
        mysqli_query($link,"INSERT INTO fi(fi,fecha) VALUES('$FI','$fecha')");
}
else if(!empty($TETA)){
        mysqli_query($link,"INSERT INTO teta(teta,fecha) VALUES('$TETA','$fecha')");
}
?>
