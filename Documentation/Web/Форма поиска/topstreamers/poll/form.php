<html>
<head>
<meta charset="utf-8">
<link rel="stylesheet" type="text/css" href="form.css">
</head>

<body>
<div class="form">
	<form action="poll.php" method="post" target="_blank">

		<input type="Hidden" name=id value=1>

		<div class="article"><div id="article_text">Кому бабоньки?</div></div>

		<?php if($_COOKIE['vote']) echo
	'<div class="voted">
		<div id="text">
			 Вы уже проголосовали (новый голос не будет засчитан)
		</div>
	</div>'
?>
		
		<center><div id="poll_form"><br>

			<div class="variant"><input type="radio" name=vote value=1 id="1">
				<label for="1" class="name"><div id="variant_text"><span><span></span></span>Alex</div></label>
			</div>

			<div class="variant"><input type="radio" name=vote value=2 id="2">
				<label for="2" class="name"><div id="variant_text"><span><span></span></span>Falex</div></label>
			</div>

			<div class="variant"><input type="radio" name=vote value=3 id="3">
				<label for="3" class="name"><div id="variant_text"><span><span></span></span>Kotleta</div></label>
			</div>

			<div id="btn_vote"><input type="Submit" value=" Голосовать! "></div><p>
			<div id="btn_result"><a href="poll.php" target="_blank">Текущие результаты</a></div>
		</div></center>

	</form>
</div>



</body>
</html>
