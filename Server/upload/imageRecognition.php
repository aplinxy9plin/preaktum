<?php
$image = file_get_contents("output.txt"); 
$countResult = 5;
function createJSON($type){
  global $image;
  $request = '{
    "requests":[
      {
        "image":{
          "content":"'.$image.'"
        },
        "features":[
          {
            "type":"'.$type.'",
            "maxResults": 5
          }
        ]
      }
    ]
  }';
  return $request;
}
function request($jsonRequest){
  $apikey = 'AIzaSyCy5byxzoigmevVSNOlQe0HSabmpxOsNOU';
                                                                                                                   
  $ch = curl_init('https://vision.googleapis.com/v1/images:annotate?key='.$apikey.'');               
  curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");                                                                     
  curl_setopt($ch, CURLOPT_POSTFIELDS, $jsonRequest);                                                                  
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);                                                                      
  curl_setopt($ch, CURLOPT_HTTPHEADER, array(                                                                          
      'Content-Type: application/json',                                                                                
      'Content-Length: ' . strlen($jsonRequest))                                                                       
  );                                                                                                                   
                                                                                                                  
  $result = curl_exec($ch);
  $resultDecode = json_decode($result); 
  return $resultDecode;
}
function data_base(){
  $mysqli = new mysqli("13.95.174.54","top4ek","Top4ek2281337!","shop");
  $mysqli->set_charset("utf8");
  $result = $mysqli->query("SELECT * FROM products");
  if ($result->num_rows > 0) {
    $x = 0;
      while($row = $result->fetch_assoc()) {
          $data[$x] = $row['name'];
          $x++;
      }
      return $data;
  }
}
$db_name = data_base();
$json = array(createJSON('LOGO_DETECTION'));
//var_dump(request($json[0]));
for ($i=0; $i < 1; $i++) { 
  $encoded = json_encode(request($json[$i]), JSON_UNESCAPED_UNICODE);
  foreach ($db_name as $key) {
    if(strpos($encoded, $key) !== false){
      echo "Название: " . $key;
    }
  }
}