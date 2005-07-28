<%-- $Header$ --%>
<%String x; 
Integer i=(Integer)pageContext.findAttribute("servletContext.status");
x=(String)pageContext.findAttribute("parade.row");
%><td><a href="browse.jsp?context=<%=x%>" ><jsp:include flush="false" page="nameNormalized.jsp"/></a> 
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
[ <a href=/servlet/log?context=<%=(String)pageContext.findAttribute("parade.row")%>>log</a>]
