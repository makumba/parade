<%-- $Header$ --%><%@ page import="java.util.*,org.makumba.parade.*" %>
<%if(pageContext.findAttribute("ant.project")!=null) {%>
ant: <jsp:include flush="false" page="antParadeRowStatus.jsp" />
<% }%>
<% if(pageContext.findAttribute("servletContext.path")!=null) {%>
&nbsp;<td valign="top"><%pageContext.setAttribute("servletContext.noPrintStatus", "x", PageContext.REQUEST_SCOPE); %>webapp: <jsp:include flush="false" page="servletContextParadeRowStatus.jsp" />
<% }%>
