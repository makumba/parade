<%-- $Header$ --%>
<%@ page import="org.makumba.parade.*,java.util.*" %>
<%-- @ taglib uri="http://www.makumba.org/presentation" prefix="mak" --%>
<html>
<head>
<title>Parade command</title>
</head>
<body>
<%
String context=request.getParameterValues("context")[0];
String path="";
if(request.getParameterValues("path")!=null)
	 path=request.getParameterValues("path")[0].trim();
path=path.replace(java.io.File.separatorChar, '/');
if(path.startsWith("/"))
	path=path.substring(1);
if(path.length()>1&& !path.endsWith("/"))
	path=path+"/";

pageContext.setAttribute("parade.sameDir", "context="+context+"&path="+path, PageContext.REQUEST_SCOPE);
pageContext.setAttribute("parade.row", context, PageContext.REQUEST_SCOPE);

    Map paradeRow = (Map)Config.invokeOperation("parade", "setParade", pageContext).get(context);	
    paradeRow.put("file.path", path);
    pageContext.setAttribute("parade.rowData", paradeRow, PageContext.REQUEST_SCOPE);
    for(Iterator i= paradeRow.entrySet().iterator(); i.hasNext();)
      {
	Map.Entry me= (Map.Entry)i.next();
	pageContext.setAttribute((String)me.getKey(), me.getValue(), javax.servlet.jsp.PageContext.REQUEST_SCOPE);
      }
try{ 
String t;
%>
<font face=courier size=-2><%t=Config.startPage("files", pageContext);%><%=t%></font>
<%
// reload check
if(t==null) return;
} catch(ParadeException e)
{
	out.println(e.getMessage());
}
%>
<br><a target=directory href=files.jsp?context=<%=context%>&path=<%=path%>>back to files</a>

<%-- if the command executed demands reload, we do it --%>
<% if(request.getParameterValues("reload")!=null ) { %>

<script language="JavaScript">
<!-- 
top.frames["directory"].document.location.href="files.jsp?<%=pageContext.findAttribute("parade.sameDir")%>"
// -->
</script>
<% } %>
</body>
</html>

