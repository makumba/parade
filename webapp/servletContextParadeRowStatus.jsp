<%-- $Header$ 
--%><%@ page import="org.makumba.parade.*" %><%
   String name=(String)pageContext.findAttribute("parade.row");
   String contextName="/"+name;
   String ctx=(String)pageContext.findAttribute("servletContext.path");
   if(ctx==null) 
      return;
   int stt=((Integer)pageContext.findAttribute("servletContext.status")).intValue();

if(pageContext.findAttribute("servletContext.noPrintStatus")==null){
if(stt==ServletContainer.RUNNING) { %>
<a href=<%="http://"+request.getServerName()+":"+request.getServerPort()+contextName %> ><%}%><%=ServletContainer.status[stt]%><% if(stt==ServletContainer.RUNNING) { %> </a> <%} %><br>
<% }
if(stt==ServletContainer.RUNNING) { %>
<a href="index.jsp?entry=<%=name%>&op=servletContextReload">reload</a> 
<a href="index.jsp?entry=<%=name%>&op=servletContextStop">stop</a> 
<%} %>
<% if(stt==ServletContainer.STOPPED) { %>
<a href="index.jsp?entry=<%=name%>&op=servletContextStart">start</a> 
<%} %>
<% if(stt!=ServletContainer.NOT_INSTALLED) { %>
<a href="index.jsp?entry=<%=name%>&op=servletContextRemove">uninstall</a> 
<%} %>
<% if(stt==ServletContainer.NOT_INSTALLED) { %>
<a href="index.jsp?entry=<%=name%>&op=servletContextInstall">install</a> 
<%} %>