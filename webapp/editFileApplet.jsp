<% /* $Header$ */ %>
<%@ page import="org.makumba.parade.*, java.util.*, java.io.*" %>

<% 
String [] context=request.getParameterValues("context");
%>
<html>
<head>
<title>parade applet editor</title>
<body TOPMARGIN=0 LEFTMARGIN=0 RIGHTMARGIN=0 BOTTOMMARGIN=0 marginwidth=0 marginheight=0 STYLE="margin: 0px"  scroll="no">

<%--Problems? Use the old
<a href="editFile.jsp?context=<%=java.net.URLEncoder.encode(request.getParameterValues("context")[0])
%>&file=<%=java.net.URLEncoder.encode(request.getParameterValues("file")[0])
%>&path=<%=java.net.URLEncoder.encode(request.getParameterValues("path")[0])%>">static editor</a><br>
--%>
<script language="JavaScript">
function openFile(context,path,file) 
{ 
document.fileEditApplet.loadFile(context,path,file) 
} 
</script>
<script language="JavaScript">
function openFileMarkRegion(context,path,file,line,column,endLine,endColumn) 
{ 
document.fileEditApplet.loadFile(context,path,file,line,column,endLine,endColumn) 
} 
</script>
</head>
<body>
<applet id="fileEditApplet" code="org.makumba.parade.applets.EditApplet" width="100%" height="100%" MAYSCRIPT>
<%if(context!=null){%>
<param name="file" value="<%=request.getParameterValues("file")[0]%>">
<param name="dir" value="<%=request.getParameterValues("path")[0]%>">
<param name="context" value="<%=request.getParameterValues("context")[0]%>">
<%}%>
</applet>

</body>
</html>
