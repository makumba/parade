<html>
<head>

<script type="text/javascript">

function reloadScript() {
	var head = document.getElementsByTagName('head').item(0);
	var old  = document.getElementById('messageScript');
	if (old) head.removeChild(old);

	script = document.createElement('script');
	script.src = "getMessageJavaScript.jsp";
	script.type = 'text/javascript';
	script.defer = true;
	script.id = 'messageScript';

	void(head.appendChild(script));
}


function startPoll(t){
	timer=setInterval('reloadScript()', t);
}

function showMessage(msg) {
//	window.status=msg;
	var msgElement = document.getElementById('msgPlaceholder');
        if(msgElement)
	   msgElement.innerHTML = '' + msg;
}


</script>
<script type="text/javascript" id="messageScript" src="getMessageJavaScript.jsp"></script>

</head>

<body>


This page was loaded at <%=new java.util.Date()%> and shows some news, refreshed every 5 seconds:
<span style="color:red;" id="msgPlaceholder">this will be raplaced</span>


<script type="text/javascript" />
  //show it initially:
  reloadScript();

  //for periodic update use:
  startPoll(5000);
  //alternatively a function that scrolls the message (from left to right) would call it when msg scrolls to an end
 
</script>

</body>
</html>