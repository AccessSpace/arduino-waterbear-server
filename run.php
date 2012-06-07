<?php

#$sScriptFile = "output.pde";
$sScriptFile = "output.ino";

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
  echo $sScript ."\n";
  file_put_contents($sOutputFolder.$sScriptFile, $sScript);
  /*$sCMD = "cd $sOutputFolder;echo \"typhoon\" | sudo -u root -S   EXTRA_LIB=/var/www/arduino-waterbear-server/external/ebl-arduino-src/";
  echo $sCMD."\n";
  $sOutput = system($sCMD);*/
  $sOutput = "In the queue";
  echo $sOutput;
  file_put_contents($sOutputFolder.'output.log', $sOutput);
  exit;
}
echo "Nothing Run";

