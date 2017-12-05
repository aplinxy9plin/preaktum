<?php
$uploads_dir = 'img';
$tmp_name = $_FILES["picture"]["tmp_name"];
$name = basename($_FILES["picture"]["name"]);
move_uploaded_file($tmp_name, "$uploads_dir/$name");
function resize_image($file, $w, $h, $crop=FALSE) {
    list($width, $height) = getimagesize($file);
    $r = $width / $height;
    if ($crop) {
        if ($width > $height) {
            $width = ceil($width-($width*abs($r-$w/$h)));
        } else {
            $height = ceil($height-($height*abs($r-$w/$h)));
        }
        $newwidth = $w;
        $newheight = $h;
    } else {
        if ($w/$h > $r) {
            $newwidth = $h*$r;
            $newheight = $h;
        } else {
            $newheight = $w/$r;
            $newwidth = $w;
        }
    }
    $src = imagecreatefromjpeg($file);
    $dst = imagecreatetruecolor($newwidth, $newheight);
    imagecopyresampled($dst, $src, 0, 0, 0, 0, $newwidth, $newheight, $width, $height);

    return $dst;
}
$img = resize_image('img/image.jpg', 768, 1024);
$base64 = base64_encode(file_get_contents('img/image.jpg'));
file_put_contents("output.txt", "");
$fp = fopen("output.txt", "w");
fwrite($fp, $base64); 
fclose($fp);  
include('imageRecognition.php');
?>