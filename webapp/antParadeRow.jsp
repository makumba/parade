<%-- $Header$ --%><%@ page import="java.util.*,org.makumba.parade.*" %>
<td><% String buildPath= (String)pageContext.findAttribute("ant.filePath");
if(pageContext.findAttribute("ant.project")!=null)
{
%>.<%=java.io.File.separator%><%=buildPath%><br><jsp:include flush="false" page="antParadeRowStatus.jsp" /><%
} // if
%>