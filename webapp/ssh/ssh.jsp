<%-- $Header: --%>
<html>
<head>
  <title>MindTerm</title>
  <ameta http-equiv="Refresh" CONTENT="2; URL=index.html">
</head>
<body onLoad="javascript:history.go(-1)">
<h1>Loading SSH Java applet....</h1>
Closing this browser window will close the applet!
<applet archive="mindtermfull.jar" code=mindbright.application.MindTerm.class width=1 height=1>
	<param name=te value="xterm">
	<param name=gm value="100x35">
	<param name=port value="22">
	<param name=cipher value="3des">
	<param name=sepframe value="true">
	<param name=quiet value="false">
	<param name=cmdsh value="false">
	<param name=verbose value="true">
	<param name=autoprops value="none">
	<param name=idhost value="false">
	<param name=alive value="10">
	<param name=rv value="true">
</applet>
</body>
</html>
