<?php
//echo($_FILES['picture']['name']);
$uploads_dir = 'img';
        $tmp_name = $_FILES["picture"]["tmp_name"];
        // basename() может предотвратить атаку на файловую систему;
        // может быть целесообразным дополнительно проверить имя файла
        $name = basename($_FILES["picture"]["name"]);
        move_uploaded_file($tmp_name, "$uploads_dir/$name");
//print_r($_FILES);
	//var_dump(file_get_contents("php://input"));
 /*$imageinfo = getimagesize($_FILES['userfile']['tmp_name']);
 if($imageinfo['mime'] != 'image/gif' && $imageinfo['mime'] != 'image/jpeg') {
  echo "Sorry, we only accept GIF and JPEG images\n";
  exit;
 }

 $uploaddir = 'img/';
 $uploadfile = $uploaddir . basename($_FILES['userfile']['name']);
 
 if (move_uploaded_file($_FILES['userfile']['tmp_name'], $uploadfile)) {
   echo "File is valid, and was successfully uploaded.\n";
 } else {
   echo "File uploading failed.\n";
 }*/
?>