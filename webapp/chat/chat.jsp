<%-- $Header: --%>
<html>
<head>
  <title>Babylon Chat</title>
  <ameta http-equiv="Refresh" CONTENT="2; URL=index.html">
</head>
<body onLoad="javascript:window.resizeTo(550, 300);" 
NOonUnload="javascript:if(confirm('Are you sure you want to close the chat applet too?')){return(true);}else{return(false);}">
<h1>Loading Babylon chat Java applet....</h1>
Closing this document will close the applet!

<applet archive="babylon.jar" code="babylonApplet.class" width="0" height="0">
<!--codebase="http://visopsys.org/andy/babylon/applet-demo/"-->
      <param name="autoconnect" value="yes">
      <param name="hidecanvas" value="no">
      <param name="locksettings" value="no">
      <param name="portnumber" value="12468">
      <param name="servername" value="<%=request.getServerName()%>">
      <param name="usepasswords" value="no">
      <param name="username">You'll need a browser with Java support to run the Babylon Chat applet!
</applet>
<p>
if it is unable to connect, make sure the <a href="http://www.visopsys.org/andy/babylon/" target="_new">Babylon chat</a> server is 
running on host <%=request.getServerName()%>. If not you can run it in parade with <code>ant babylon</code>
</body>
</html>
