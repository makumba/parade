<html>
<head>

<script type="text/javascript">
var timer;

function reloadScript() {
	//remove script, if exists:
	var head = document.getElementsByTagName('head').item(0);
	var old  = document.getElementById('messageScript');
	if (old) head.removeChild(old);

	//implant a new script:
	script = document.createElement('script');
	script.src = "getMessageJavaScript.jsp";
	script.type = 'text/javascript';
	script.defer = true;
	script.id = 'messageScript';

	void(head.appendChild(script));
}


function startPoll(t){
	reloadScript();
	timer=self.setInterval('reloadScript()', t);
}

function showMessage(msg) {
	//window.status=msg;
	var msgElement = document.getElementById('msgPlaceholder');
	msgElement.innerHTML = '' + msg;
}

</script>

</head>

<body onload="void(startPoll(3000));">


This page was loaded at <%=new java.util.Date()%> and shows some news, refreshed every 3 seconds:
<span style="color:red;" id="msgPlaceholder">this will be raplaced</span>


</body>
</html>