<%-- $Header$ --%>
<td><% if(pageContext.findAttribute("file.file")==null) { %>
<img src="images/folder-broken.gif" border="0"></td>
<% } else { %>
<img src="images/folder.gif" border="0"></td>
<% } %>