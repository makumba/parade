<%-- $Header$ --%>
<form action="editFile.jsp" target="directory">
<%
String context=request.getParameterValues("context")[0];

String path="";
if(request.getParameterValues("path")!=null)
	path=request.getParameterValues("path")[0];
%>
<input type=hidden size="50" value="<%=path.length()>1?path+java.io.File.separator:""%>" name=path>
<input type=hidden value="<%=context%>" name=context>
Create new file:<input type=text name=file>
<input type=submit value=Edit>
</form>
