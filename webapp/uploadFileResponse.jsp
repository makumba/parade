<%-- $Header$ --%>
<%@ page import="org.makumba.parade.*, java.util.*, java.io.*" %>
<%@ taglib uri="http://www.makumba.org/presentation" prefix="mak" %>
<html>
<body>
<mak:attribute name="context" var="context"/>
<mak:attribute name="path" var="path"/>
<mak:attribute name="theFile_filename" var="file"/>

<%
String contextRoot;
Map data=null; 
try{
   data= (Map)Config.invokeOperation("parade", "setParade", pageContext).get(context);
   contextRoot= (String)data.get("parade.path");
}catch(ParadeException e)
	{
	  %>error while reading data: <%=e%><%
	  return; 
	}

%>
<h3>Uploading file:</h3>
file: <%=context%>/<%=path%><%=file%><br>
content type: <mak:attribute name="theFile_contentType" /><br>
content length: <mak:attribute name="theFile_contentLength" /><br>
Saving to file: <%=contextRoot+File.separator+path+file%>...

<% // we need to do this in order for the attribute to be extracted %>
<mak:attribute name="theFile" var="content" />

<% try {
  OutputStream dest= new BufferedOutputStream(new FileOutputStream(contextRoot+File.separator+path+file));
  ((org.makumba.Text)content).writeTo(dest);
  dest.close();
}catch(Exception ew)
	{
	  %>Error writing file: <%=ew%><%
	  return; 
	}
%>
<b>done</b>.

<script language="JavaScript">
<!-- 
top.frames["directory"].document.location.href="files.jsp?context=<%=context%>&path=<%=path%>"
// -->
</script>
</body>
</html>