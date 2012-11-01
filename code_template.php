<?php
$sBase = 'templates/';

$sType = $_REQUEST['type'];

//Should be genereated by a folder scan
$aTemplateNames = array(
	'ardumoto' => 'arduino-simple-robot/ardumoto.pde',
	'servos' => 'arduino-simple-robot/servos.pde',
	'adafruitmotorshield'=>'arduino-simple-robot/adafruit-motorshield.pde',
	'arduino'=>'arduino/default.pde'
	);

$aTemplates = array();

foreach($aTemplateNames as $sName => $sFile)
{
  if (is_null($sType) || $sType == dirname($sFile))
  {
    $sFullFile = $sBase.$sFile;
    
    if(file_exists($sFullFile))
    {
      $aTemplates[$sName] = file_get_contents($sFullFile);
    }
  }
}

$sRet = json_encode($aTemplates);

echo $sRet;
