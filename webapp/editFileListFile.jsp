<%-- $Header$ --%>
<atd><%
String fileName=(String)pageContext.findAttribute("file.name");
String fl=fileName.toLowerCase();

if(!(fl.endsWith(".jar")||fl.endsWith(".zip")||fl.endsWith(".tar")||fl.endsWith(".gif")||fl.endsWith(".jpg")||fl.endsWith(".jpeg")||fl.endsWith(".png") || fl.endsWith(".avi")||fl.endsWith(".mpg") || fl.endsWith(".mpeg") || fl.endsWith(".mov")|| fl.endsWith(".au")||fl.endsWith(".mid") || fl.endsWith(".vaw") || fl.endsWith(".mp3") ))
//if(true)
  {%>&nbsp;<a
href="editFile.jsp?<%=pageContext.findAttribute("parade.sameDir")%>&file=<%=java.net.URLEncoder.encode((String)pageContext.findAttribute("file.name"))%>"
title="Edit <%=pageContext.findAttribute("file.name")%>"><img src="images/edit.gif" alt="Edit" border=0></a>&nbsp;<a href="javascript:editFileInApplet('<%=java.net.URLEncoder.encode((String)pageContext.findAttribute("file.name"))%>')" title="Open <%=pageContext.findAttribute("file.name")%> in Applet editor">E!</a><% } 

if(pageContext.findAttribute("file.file")!=null) { 
%>&nbsp;<a href="#delete" title="delete it"
onClick="javascript:deleteFile('<%=java.net.URLEncoder.encode((String)pageContext.findAttribute("file.name"))%>');"><img src="images/delete.gif" alt="Delete" border=0></a>
<% } %>