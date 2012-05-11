<?php

$sScriptFile = "output.pde";
$sOutputFolder = "/tmp/output/";

if(!file_exists($sOutputFolder))
{
	mkdir($sOutputFolder);
	copy("external/arscons/SConstruct", $sOutputFolder."SConstruct");

}



$sScript = false;
if(isset($_POST['script']))
{
  $sScript = $_POST['script'];
  //echo $sScript ."\n";
  file_put_contents($sOutputFolder.$sScriptFile, $sScript);
  $sCMD = "cd $sOutputFolder;echo \"typhoon\" | sudo -u root -S scons upload ARDUINO_BOARD=uno  ARDUINO_PORT=/dev/ttyACM0  ";//EXTRA_LIB=/home/tech/ebl-arduino/";
  echo $sCMD."\n";
  $sOutput = system($sCMD);
  
  echo $sOutput;
  file_put_contents($sOutputFolder.'output.log', $sOutput);
  exit;
}
echo "Nothing Run";

