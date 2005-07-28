<% /* $Header$ */ %>
<%@page import="java.util.*" %>
<ajsp:include page="header.jsp?title=System info" flush="false"/>

<h1>System Information</h1>

<h2>Client info</h2>
Browser: <%=request.getHeader("User-Agent")%><br>
Host (IP): <%=request.getRemoteHost() %> (<%=request.getRemoteAddr() %>)<br>

<h2>Server info</h2>
<%   String port=String.valueOf(request.getServerPort());
	if(port.equals("80")) {port="";}
 		else {port=":"+port;}
%>
Server protocol, name and port: 
<a href="<%=request.getScheme()%>://<%=request.getServerName() %><%=port%>"><%=request.getScheme()%>://<%=request.getServerName() %><%=port%></a><br>
Server software: <%=pageContext.getServletContext().getServerInfo() %><br>



<h2>Java on server info</h2>

<% 
  java.lang.Runtime rt=java.lang.Runtime.getRuntime(); 
%>
<table border="0" cellspacing=0 cellpadding=0>
<tr bgcolor="#cccccc"><Th colspan=2>JVM Memory
<tr><td>Total available:&nbsp;<td align=right><%=org.makumba.parade.Config.readableBytes(rt.totalMemory())%></td></tr>
<tr bgcolor="#eeeeee"><td>Currently using:&nbsp;<td align=right><%=org.makumba.parade.Config.readableBytes(rt.totalMemory()-rt.freeMemory())%></td></tr>
<tr><td>Free:&nbsp;<td align=right><%=org.makumba.parade.Config.readableBytes(rt.freeMemory())%></td></tr>
</table>

<%
  //Properties props;
  //props = System.getProperties();


  Properties sysprops = System.getProperties() ;
  Enumeration enprop = sysprops.propertyNames() ;
  String str = "" ;
    

%>

<table border="0" cellspacing=0 cellpadding=0>
<tr bgcolor="#cccccc"><Th>Property<th>Value
<% int line=0;
   while ( enprop.hasMoreElements() ) 
   {  String key = (String) enprop.nextElement() ; 
      line=line+1; %> 
<tr bgcolor=<%="\""%>#<% if(line%2==0){%>eeeeee<%}else{%>ffffff<%}%>>
<td valign="top"><%=key%>:&nbsp;<td><pre><%=key.endsWith("path")?sysprops.getProperty(key).replace(sysprops.getProperty("path.separator").charAt(0),'\n'):(((String)sysprops.getProperty(key)).startsWith("http://"))?"<a href="+sysprops.getProperty(key)+">"+sysprops.getProperty(key)+"</a>":sysprops.getProperty(key)%></tr>
<% } %>
</table>

<ajsp:include page="footer.jsp" flush="false"/>
