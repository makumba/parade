<%-- $Header$ --%>
<%@ page import="org.makumba.parade.*,java.util.*" %>
<%
String path=((String)pageContext.findAttribute("file.path")).replace(java.io.File.separatorChar, '/');
String context=request.getParameterValues("context")[0];
%>
<font size=+1>[<a href="files.jsp?context=<%=context%>&path="><jsp:include flush="false" page="nameNormalized.jsp" /></a>]/<%
if(path.startsWith("/")) path=path.substring(1);
String upDir="";
String linkPath="";
while(path.indexOf("/")>0) {
   upDir=path.substring(0,path.indexOf("/"));
   linkPath=linkPath+"/"+upDir;
   path=path.substring(path.indexOf("/")+1);
%><a href="files.jsp?context=<%=context%>&path=<%=linkPath%>"><%=upDir%></a>/<%
 } %>
</font>

<% if(pageContext.findAttribute("file.baseFile")==null) { %>
<img src="images/folder-open-broken.gif">
<% } else { %>
<img src="images/folder-open.gif">
<br><font size=-2><%=pageContext.findAttribute("file.baseFile")%></font>
<% } %>

