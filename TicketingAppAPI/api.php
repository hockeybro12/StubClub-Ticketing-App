<?php
//API implementation to come here
if (session_status() == PHP_SESSION_NONE) {
    	session_start();
}
//ios app only accepts json responses, so we need this
function errorJson($msg){
	print json_encode(array('error'=>$msg));
	exit();
}

//register a user
function register($user, $pass, $email, $creditcardnumber) {
	//check if username exists
	//create a query
	$login = query("SELECT username FROM login WHERE username='%s' limit 1", $user);
	//if the number of objects in login array(count) is more than 0, then the username exists
	if (count($login['result'])>0) {
		errorJson('Username already exists');
	}
	
	//insert a new record of the username and password into the database
	$result = query("INSERT INTO login(username, password, email, creditcardnumber) VALUES('%s','%s', '%s', '%s')", $user, $pass, $email, $creditcardnumber);
		
	if (!isset($result['error'])) {
		//success
		login($user, $pass);
	} else {
		//error
		//errorJson($result);
		errorJson('Registration failed' . $result['error']);
	}
}


function login($user, $pass) {
	if (session_status() == PHP_SESSION_NONE) {
    	session_start();
	}
	$result = query("SELECT IdUser, username FROM login WHERE username='%s' AND password='%s' limit 1", $user, $pass);
 
	if (count($result['result'])>0) {
		//authorized
		$_SESSION['IdUser'] = $result['result'][0]['IdUser'];
		print json_encode($result);
	} else {
		//not authorized
		errorJson('Authorization failed yea' . $result['error']);
	}
}


//upload API
function upload($eventCode, $sectionNumber, $seatNumber, $rowNumber, $price, $IdUser) {
	
	$result = query("INSERT INTO tickets(SectionNumber, TicketPrice, SeatNumber, RowNumber, EventID, TicketSellerID) VALUES ('%s', '%s', '%s', '%s', (SELECT EventID FROM events WHERE EventName='%s'), '%s')", $sectionNumber, $price, $seatNumber, $rowNumber, $eventCode, $IdUser);
	
	if (!isset($result['error'])) {
		// if no error occured, print out the JSON data of the 
		// fetched photo data
		//print json_encode($result);
	} else {
		//there was an error, print out to the iPhone app
		errorJson('Upload is broken');
	}
}

//request upload API
function requestUpload($eventCode, $sectionNumber, $price, $IdUser) {
	
	$result = query("INSERT INTO requests(SectionNumber, TicketPrice, EventID, TicketSellerID) VALUES ('%s', '%s', (SELECT EventID FROM events WHERE EventName='%s'), '%s')", $sectionNumber, $price, $eventCode, $IdUser);
	
	if (!isset($result['error'])) {
		// if no error occured, print out the JSON data of the 
		// fetched photo data
		//print json_encode($result);
	} else {
		//there was an error, print out to the iPhone app
		errorJson('Upload is broken' . $result);
	}
}


//logout API
function logout() {

	//destroy all session data
	$_SESSION = array();
	session_destroy();
}

function stream($EventID) {

	
	$result = query("SELECT * FROM events INNER JOIN tickets ON events.EventID = tickets.EventID  INNER JOIN photos ON photos.EventID = events.EventID AND photos.SectionNumber = tickets.SectionNumber WHERE events.EventID = (SELECT EventID FROM events WHERE EventName = '%s' AND TicketBuyerID='0')", $EventID);
 
	if (!isset($result['error'])) {
		// if no error occured, print out the JSON data of the 
		print json_encode($result);
	} else {
		//there was an error, print out to the iPhone app
		errorJson('Stream is broken');
	}
}

function purchase($IdUser, $TicketID) {
	$result = query("UPDATE tickets SET TicketBuyerID='%s' WHERE TicketID = '%s'", $IdUser, $TicketID);
 
	if (!isset($result['error'])) {
		// if no error occured, print out the JSON data of the 
		print json_encode($result);
	} else {
		//there was an error, print out to the iPhone app
		errorJson('Stream is broken');
	}
}

function purchaseRequests($IdUser, $TicketID) {
	$result = query("UPDATE requests SET TicketBuyerID='%s' WHERE RequestID = '%s'", $IdUser, $TicketID);
 
	if (!isset($result['error'])) {
		// if no error occured, print out the JSON data of the 
		print json_encode($result);
	} else {
		//there was an error, print out to the iPhone app
		errorJson('Stream is broken');
	}
}


function streamRequests($EventID) {

	
	$result = query("SELECT * FROM events INNER JOIN requests ON events.EventID = requests.EventID  INNER JOIN photos ON photos.EventID = events.EventID AND photos.SectionNumber = requests.SectionNumber WHERE events.EventID = (SELECT EventID FROM events WHERE EventName = '%s' AND TicketBuyerID='0')", $EventID);
 
	if (!isset($result['error'])) {
		// if no error occured, print out the JSON data of the 
		print json_encode($result);
	} else {
		//there was an error, print out to the iPhone app
		errorJson('Stream is broken');
	}
}

function ownership($IdUser) {
	$result = query("SELECT *, EventID, (SELECT EventCategory FROM events WHERE EventID=tickets.EventID) FROM tickets WHERE TicketSellerID='%s' AND TicketBuyerID='0'", $IdUser);
 
	if (!isset($result['error'])) {
		// if no error occured, print out the JSON data of the 
		print json_encode($result);
	} else {
		//there was an error, print out to the iPhone app
		errorJson('Stream is broken');
	}
}





?>