<%-- $Header$ --%>
<% Integer reload=(Integer)pageContext.findAttribute("reload"); %>
<META HTTP-EQUIV="Refresh" CONTENT="<%=reload%>; URL="index.jsp">
Reloading Parade. You will be redirected in <%=reload%> seconds. Do not try to load Parade pages in the meantime.<br>

If you see errors after the redirection, increase the redirect time by editing servletContext.properties .
