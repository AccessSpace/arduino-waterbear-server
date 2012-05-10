<?php

$sScriptFile = "output.pde";
$sOutputFolder = "output/";

$sScript = false;
if(isset($_POST['script']))
{
  $sScript = $_POST['script'];
  file_put_contents($sOutputFolder.$sScriptFile, $sScript);
  
  $sOutput = shell_exec("cd $sOutputFolder; scons ; scons upload");
  
  echo $sOutput;
  file_put_contents($sOutputFolder.'output.log', $sOutput);
  exit;
}
echo "Nothing Run";

