<%-- $Header$ --%>
<%String x; 
Integer i=(Integer)pageContext.findAttribute("servletContext.status");
%><td><a href="browse.jsp?context=<%=x=(String)pageContext.findAttribute("parade.row")%>" ><jsp:include flush="false" page="nameNormalized.jsp"/></a> 
<% if(i!=null)
   if(i.intValue()==org.makumba.parade.ServletContainer.RUNNING)
{ %>
(<a href="<%=x%>" target="surf">surf</a>)
<% }else if(i.intValue()==org.makumba.parade.ServletContainer.NOT_INSTALLED){
%>
(press "install" to surf)
<% } else{ %>
(press "start" to surf)
<%} %>
[ <a href=/servlet/log?context=<%=x=(String)pageContext.findAttribute("parade.row")%>>log</a>]
