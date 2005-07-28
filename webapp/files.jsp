<%-- $Header$ --%>
<%@ page import="org.makumba.parade.*,java.util.*" %>
<html>
<head>
<% response.setDateHeader("Expires", System.currentTimeMillis() + 10);%>
<title>File Browser</title>
</head>
<body>
<%
String context=request.getParameterValues("context")[0];
String commandDomain="parade";
if(request.getParameterValues("commandDomain")!=null)
	 commandDomain=request.getParameterValues("commandDomain")[0].trim();
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

// response headers
for(Iterator cols=Config.getColumns("files.responseHeaders"); cols.hasNext(); ){
	%><jsp:include flush="false" page="<%=cols.next()+\"Response.jsp\" %>" /><%
}

try{ 
String t;
%>
<%t=Config.startPage(commandDomain, pageContext);%><%=t%>
<%
// reload check
if(t==null) return;
} catch(ParadeException e)
{
	out.println(e.getMessage());
}
// we read and order the data
List orderedResult= new ArrayList();
try{
	orderedResult.addAll(Config.invokeOperation("files", "setFileData", pageContext).values());
}catch(ParadeException e)
	{ out.println("error during reading data "+e); return; }

Collections.sort(orderedResult, new MapComparator(request, "file.name"));

%>
<p align=left>
<form name="files" style="margin:0px;"> 
<input type="hidden" name="path" value="<%=path%>">
<input type="hidden" name="context" value="<%=context%>">
<input type="hidden" name="actionID" value="">

<%// headers
for(Iterator cols=Config.getColumns("files.headers"); cols.hasNext(); ){
	%><jsp:include flush="false" page="<%=cols.next()+\".jsp\" %>" /><%
}
%>

<table border="0" width="100%" cellspacing="0" cellpadding="2"> 
<tr bgcolor="#cccccc">
<%
int ncols=0;
// ask column headings to get displayed
// it's up to them to decide if they want a separate column or not
for(Iterator cols=Config.getColumns("files.columns"); cols.hasNext(); ){
	ncols++;
	%><jsp:include flush="false" page="<%=cols.next()+\"FileListHeading.jsp\" %>" /><%
}

int ctr=0;
Map d=null;
for(Iterator dt= orderedResult.iterator(); dt.hasNext(); )
{
ctr++;
%>
<tr<%=(ctr%2==0)?" bgcolor='eeeeee'":""%>>
<%	
	if(d!=null)
	for(Iterator attrs= d.keySet().iterator(); attrs.hasNext(); )
		pageContext.removeAttribute((String)attrs.next(), PageContext.REQUEST_SCOPE);

	d= (Map)dt.next();
	for(Iterator attrs= d.keySet().iterator(); attrs.hasNext(); ){
		String attr= (String)attrs.next();
		pageContext.setAttribute(attr, d.get(attr), PageContext.REQUEST_SCOPE);
	}
	if(d.get("isFolder")!=null)
	for(Iterator cols=Config.getColumns("files.columns"); cols.hasNext();)
{
	%><jsp:include flush="false" page="<%=cols.next()+\"FileListFolder.jsp\" %>" /><% 
}
else
	for(Iterator cols=Config.getColumns("files.columns"); cols.hasNext();)
{
	%><jsp:include flush="false" page="<%=cols.next()+\"FileListFile.jsp\" %>" /><% 
}

}
%>
<tr bgcolor="#cccccc"><td colspan=<%=ncols%>><font size=-5>&nbsp;
</table>
<% // footers in form
for(Iterator cols=Config.getColumns("files.footersInForm"); cols.hasNext(); ){
	%><jsp:include flush="false" page="<%=cols.next()+\".jsp\" %>" /><%
}
%>
</form>
<% // footers
for(Iterator cols=Config.getColumns("files.footers"); cols.hasNext(); ){
	%><jsp:include flush="false" page="<%=cols.next()+\".jsp\" %>" /><%
}
%>

</p>
</body>
</html>

