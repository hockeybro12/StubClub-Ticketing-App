<?php
session_start();
date_default_timezone_set('America/Los_Angeles');
require("lib.php");
require("api.php");

header("Content-Type: application/json");

switch ($_POST['command']) {
	case "login":
		login($_POST['username'], $_POST['password']); 
		break;
 
	case "register":
		register($_POST['username'], $_POST['password'], $_POST['emailaddress'], $_POST['creditcardnumber']); 
		break;
 
	case "upload":
		upload($_POST['EventCode'], $_POST['SectionNumber'], $_POST['SeatNumber'], $_POST['RowNumber'], $_POST['Price'], $_POST['IdUser']);
		break;
		
	case "requestUpload":
		requestUpload($_POST['EventCode'], $_POST['SectionNumber'], $_POST['Price'], $_POST['IdUser']);
		break;
	
	case "logout":
		logout();
		break;

	case "purchase":
		purchase($_POST['IdUser'], $_POST['TicketID']);
		break;
		
	case "purchaseRequests":
		purchaseRequests($_POST['IdUser'], $_POST['TicketID']);
		break;	
		
	case "stream":	
		stream($_POST['EventName']);
		break;
		
	case "streamRequests":
		streamRequests($_POST['EventName']);
		break;
	
	case "ownership":
		ownership($_POST['IdUser']);
		break;
		
}


exit();
?>