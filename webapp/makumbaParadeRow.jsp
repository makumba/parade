<%-- $Header$ --%>
<td><%if(pageContext.findAttribute("makumba.version")!=null)
{%><%=pageContext.findAttribute("makumba.version")%><% } 
%><%if(pageContext.findAttribute("makumba.database")!=null)
{%>, <%=pageContext.findAttribute("makumba.dbsv")%><br><font size=-2><%=pageContext.findAttribute("makumba.database")%></font><% } %>
