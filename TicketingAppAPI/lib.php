<?php

if (session_status() == PHP_SESSION_NONE) {
    	session_start();
}

//setup db connection
$link = mysqli_connect("localhost","root","hackillinois");
mysqli_select_db($link, "TicketingApp");


//executes a given sql query with the params and returns an array as result
function query() {
	global $link;
	$debug = false;
	
	//get the sql query
	//get array of the function's argument list
	$args = func_get_args();
	//shifts first value of array, basically shortens by 1 element and moves everything down
	$sql = array_shift($args);

	//secure the input
	for ($i=0;$i<count($args);$i++) {
		//take care of weird simbles like %#
		$args[$i] = urldecode($args[$i]);
		//create a string you can use in an sql statement
		$args[$i] = mysqli_real_escape_string($link, $args[$i]);
	}
	
	//build the final query
	//vsprintf returns a formatted string
	$sql = vsprintf($sql, $args);
	
	if ($debug) print $sql;
	
	//execute and fetch the results
	$result = mysqli_query($link, $sql);
	//if no errors and the query returned a value
	if (mysqli_errno($link)==0 && $result) {
		
		//create a rows array
		$rows = array();

		//if the value is not true
		if ($result!==true)
		//while there are rows in the result array from the query
		while ($d = mysqli_fetch_assoc($result)) {
			//array_push pushes one or more elements onto the end of the array
			//add that row to the rows array created earlier
			array_push($rows,$d);
		}
		
		//return json
		return array('result'=>$rows);
		
	} else {
	
		//error
		return array('error'=>'Database error');
	}
}


