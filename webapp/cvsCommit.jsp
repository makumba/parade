<%-- $Header$ --%>
<%@ page import="org.makumba.parade.*,java.util.*" %>
<%--@ taglib uri="http://www.makumba.org/presentation" prefix="mak" --%>
<html>
<head>
<title>Parade command</title>
</head>
<body onLoad="javascript:document.form.elements[0].focus();">
<%
String context=request.getParameterValues("context")[0];
String path="";
if(request.getParameterValues("path")!=null)
	 path=request.getParameterValues("path")[0].trim();
path=path.replace(java.io.File.separatorChar, '/');
if(path.startsWith("/"))
	path=path.substring(1);
if(path.length()>1&& !path.endsWith("/"))
	path=path+"/";
String file="";
if(request.getParameterValues("entry")!=null)
	 file=request.getParameterValues("entry")[0].trim();
%>
<form action=command.jsp name="form">
Committing <b><%=file%></b> with message:<br>
<textarea name=cvs.committMessage rows=3 cols=40>
</textarea><br>
<input type=hidden name=op value=cvs>
<input type=hidden name=cvs.op value=commit>
<input type=hidden name=context value=<%=context%>>
<input type=hidden name=path value=<%=path%>>
<input type=hidden name=entry value=<%=file%>>
<input type=hidden name=reload value=yes>
<input type=submit value="(c)ommit" accesskey="c">
</form>