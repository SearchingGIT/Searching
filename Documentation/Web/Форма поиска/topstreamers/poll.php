<?php 
	//ini_set('display_startup_errors',1);
	//ini_set('display_errors',1);
	//error_reporting(-1);

	include $_SERVER['DOCUMENT_ROOT'].'/poll/pData.class.php'; 
	include $_SERVER['DOCUMENT_ROOT'].'/poll/pDraw.class.php'; 
	include $_SERVER['DOCUMENT_ROOT'].'/poll/pImage.class.php'; 

	header("Content-Type: text/html; charset=utf-8");

	$data = File("poll.dat");
	$vote = $_POST['vote'];
	if ($vote) setcookie("vote", 1,time()+3600); //60*60*24
	

	if(!$_COOKIE['vote'])
	{
		if ($vote) 
		{
			$f = fopen("poll.dat","w");
			fputs($f, "$data[0]");

			for ($i=1;$i<count($data);$i++) 
			{
				$votes = split("~", $data[$i]);
				if ($i==$vote) $votes[0]++;
				fputs($f,"$votes[0]~$votes[1]");
			}

		fclose($f);
		}
	}

	$resultsC = array();
	$resultsA = array();

	for ($i=1;$i<count($data);$i++) 
		{
			$votes = split("~", $data[$i]);
			//echo "$votes[1]: <b>$votes[0]</b><br>";
			$resultsC[$i] = $votes[0];
			$resultsA[$i] = $votes[1];
		}

	

	$vote = "";

	$MyData = new pData;
	//$MyData->removeSerie("Hits");
	//$MyData->removeSerie("Streamers");
	
	$MyData->AddPoints(array($resultsC[1],$resultsC[2],$resultsC[3],$resultsC[4],$resultsC[5],$resultsC[6],$resultsC[7]),"Hits");
	$MyData->setAxisName(0,"Hits");    
	$MyData->AddPoints(array("Alex", "Falex", "Kotleta","Vazelink","Romaxa","Batya","Mamka"),"Streamers");    
	$MyData->setAbscissa("Streamers");
	$serieSettings = array("R"=>200,"G"=>50,"B"=>50,"Alpha"=>80);
	$MyData->setPalette("Hits",$serieSettings);
	$myPicture = new pImage(1000,400,$MyData,TRUE);
	$myPicture->setFontProperties(array("FontName"=>"/var/www/html/csgo/poll/pChart/fonts/verdana.ttf","FontSize"=>10, "R"=>255,"G"=>255,"B"=>255));
	$myPicture->setGraphArea(60,60,940,260);
	//$Settings = array("R"=>0, "G"=>0, "B"=>0);
	//$myPicture->drawFilledRectangle(0,0,1000,400,$Settings);
	$myPicture->drawFilledRectangle(60,60,940,260,array("R"=>0,"G"=>0,"B"=>0,"Surrounding"=>-200,"Alpha"=>10));
	$scaleSettings = array("GridR"=>200,"GridG"=>200,"GridB"=>200,"DrawSubTicks"=>FAlSE,"CycleBackground"=>TRUE,"Mode"=>SCALE_MODE_START0,"Pos"=>SCALE_POS_TOPBOTTOM, "Factors"=>array(1));
	$myPicture->drawScale($scaleSettings);	
	$myPicture->setShadow(TRUE,array("X"=>1,"Y"=>1,"R"=>0,"G"=>0,"B"=>0,"Alpha"=>10));
	//$myPicture->drawScale(array("DrawSubTicks"=>TRUE));
	//$myPicture->setShadow(TRUE,array("X"=>1,"Y"=>1,"R"=>0,"G"=>0,"B"=>0,"Alpha"=>10));
	$Palette = array("R"=>188,"G"=>224,"B"=>46,"Alpha"=>100);
	$settings = array("DisplayValues"=>TRUE, "DisplayR"=>255, "DisplayG"=>255, "DisplayB"=>255, "DisplayShadow"=>TRUE, "Surrounding"=>30, "DisplayPos"=>LABEL_POS_INSIDE);
	$myPicture->drawBarChart($settings);
	//$myPicture->drawBarChart(array("DisplayValues"=>TRUE,"DisplayColor"=>DISPLAY_AUTO,"Rounded"=>TRUE,"Surrounding"=>60));
	$myPicture->Render('/var/www/html/csgo/chart.png');

?>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>Romaxa Donations</title>
		<link href="css/style_md4poll.css" type="text/css" rel="stylesheet" />
		<link href="css/poll.css" type="text/css" rel="stylesheet" />
	</head>
	<body>
	
	
        <div id="wrapper">
		<video autoplay loop muted class="bgvideo" id="bgvideo">
   <source src="images/golden.webm" type="video/webm"></source>
  </video>
		     <div id="header">
			 <div id="logo">
			 <a href="index.html"><img src="images/Site1.png" alt="Логотип" /></a>
			 
			 </div>
			 <div id="menu">
			 <ul>
              <li><a  href="index.html">Home</li>
			   <li><a href="index1.html">About</li>
			    <li><a class="current"  href="poll.php">Poll</li>
				<li class="twitch"><a  href="http://www.twitch.tv/romaxaa" target="_blank">Twitch.tv</li>
				</a>
				</ul>
                </div>
			 </div>
			 <div id="content">
			 <div class="divider"></div>
			 

			<?php if($_COOKIE['vote']) echo
				'<div class="voted">
					<div id="text">
						Вы уже проголосовали
					</div>
				</div>'?>

	 <div class="result">
		<div id="rText">
			Результаты:
		</div>
	 </div>

	<center><img src="chart.png"></center>
	


			 
			 <div class="divider"></div>
			 <div id="footer"</div>
			 <p>Copyright &copy; 2015 <a href "index.html">Romaxa Ru</a></p>
			 <h4> If you want to Help project</h4>
			 <h5> WebMoney:
			 </h5>
			 <h6>Z392408423304</h6>
			 <h7>R344780660510</h7>
			 
			 </div>
			 
			 
		
		</div>
	</body>
</html>
