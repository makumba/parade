<%-- $Header$ --%>
<td>
<%
   String ctx=(String)pageContext.findAttribute("servletContext.path");
   if(ctx==null) 
      return;
%><%=ctx%><%=java.io.File.separator%>, <jsp:include flush="false" page="servletContextParadeRowStatus.jsp" />
