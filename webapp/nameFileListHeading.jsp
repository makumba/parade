<%-- $Header$ --%>
<th><a href=files.jsp?<%=pageContext.findAttribute("parade.sameDir")%>&order=file.name>Name</a>
<%
 String context=request.getParameterValues("context")[0];

String path="";
if(request.getParameterValues("path")!=null)
	path=request.getParameterValues("path")[0];
if(path.startsWith("/"))
	path=path.substring(1);
if(!path.endsWith("/"))
	path=path=path+"/";
%>
<a href="newUploadFile.jsp?context=<%=context%>&path=<%=path%>" target="command"><img src="images/newfile.gif" alt="new file" border=0></a>