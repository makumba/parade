<%-- $Header$ --%>
<%@ taglib uri="http://www.makumba.org/presentation" prefix="mak"%>
<%
org.makumba.parade.MakumbaManager.response(pageContext);

if(pageContext.findAttribute("makumba.response")!=null) { %>
<%=pageContext.findAttribute("makumba.response")%>
<% } %>
