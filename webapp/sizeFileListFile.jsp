<%-- $Header$ --%>
<td align="right"><%
if(pageContext.findAttribute("file.size")!=null)
{ 
long fs=((Long)pageContext.findAttribute("file.size")).longValue();
if(fs>0l) {
%><a title="<%=fs%> bytes"><%=org.makumba.parade.Config.readableBytes(fs)%></a>
<% } else { %>
<font color="#999999"><i>empty<i></font>
<% } 
} else { %><font color="#999999"><i>missing<i></font>
<% } %>
