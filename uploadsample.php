<?php
var_dump($_FILES);
if(isset($_POST["upload"]))
{
	if(isset($_FILES["soundFile"]))
	{
	if(is_uploaded_file($_FILES["soundFile"]["tmp_name"]))
	{
		move_uploaded_file($_FILES["soundFile"]["tmp_name"], $_POST["upload"].".caf");
		echo "soundfile copy success:";
	}
	}
	else
	{
		echo "soundFile is not exist.";
	}
}
else
{
	var_dump($_POST);
}
?>