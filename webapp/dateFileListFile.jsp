<%-- $Header$ --%>
<td>
<% if(pageContext.findAttribute("file.age")!=null){ %>
<a title="<%=new java.util.Date(((Long)pageContext.findAttribute("file.date")).longValue())%>"><%=org.makumba.parade.Config.readableTime(((Long)pageContext.findAttribute("file.age")).longValue())%></a>
<% } else 
{%>&nbsp; <%}%>
