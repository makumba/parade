<%-- $Header$ --%>
<%@ page import="org.makumba.parade.*,java.util.*" %>
<%--@ taglib uri="http://www.makumba.org/presentation" prefix="mak" --%>
<html>
<head>
<title>Parade</title>
</head>
<body>

<% // response, etc
try{ 
String t;
%>
<%t=Config.startPage("parade", pageContext);%><%=t%>
<% // reload check
if(t==null) return;
if(t.length()>0)out.println("<br>");
} catch(ParadeException e)
{
	out.println(e.getMessage());
}
%>

<% // ordering the result
// we read and order the data
List orderedResult= new ArrayList();
try{
	orderedResult.addAll(Config.invokeOperation("parade", "setParade", pageContext).values());
}catch(ParadeException e)
	{ out.println("error during reading data "+e); return; }

Collections.sort(orderedResult, new MapComparator(request, "parade.row"));
%>

<% // parade headers
for(Iterator cols=Config.getColumns("parade.headers"); cols.hasNext(); ){
%>
	<jsp:include flush="false" page="<%=cols.next()+\".jsp\" %>" />
<%
}
%>

<table border=1>

<% // table heading
int ncols=0;
// ask column headings to get displayed
// it's up to them to decide if they want a separate column or not
for(Iterator cols=Config.getColumns("parade.columns"); cols.hasNext(); ){
ncols++;
%>
	<jsp:include flush="false" page="<%=cols.next()+\"ParadeHeading.jsp\" %>" />
<%
}
%>

<%--
  ### Parade header (adding new row) -- commented out; should be moved to another file (parts of it did work) ###

<tr> <form action=index.jsp >
<input type=hidden value=addParadeRow name=op> 
<% // add form
String coljsp;
for(Iterator cols=Config.getColumns("parade.addColumns"); cols.hasNext(); )
if((coljsp=(String)cols.next()).length()==0){ %><td><%}else
{
%>
	<jsp:include flush="false" page="<%=coljsp+\"ParadeAdd.jsp\" %>" />
<%
}
%>

<tr> <td colspan=<%=ncols%>>
<font size=-2>
(*) compulsory
(1)At least one is compulsory
<input type=submit value="ADD ROW!">
<font color=red>Note: adding non-existing directories doesn't work yet! Contact the administrators.</font>
</td>
</form>

  ### Parade header ###
--%>
<% 
for(Iterator dt= orderedResult.iterator(); dt.hasNext(); )
{
%>
<tr>
<% // writing the values to the page context
	Map d= (Map)dt.next();
	for(Iterator attrs= d.keySet().iterator(); attrs.hasNext(); ){
		String attr= (String)attrs.next();
		pageContext.setAttribute(attr, d.get(attr), PageContext.REQUEST_SCOPE);
	}

// columns
	for(Iterator cols=Config.getColumns("parade.columns"); cols.hasNext();)
{
%>
	<jsp:include flush="false" page="<%=cols.next()+\"ParadeRow.jsp\" %>" />
<% 
}
// deleting the values from the page context
	for(Iterator attrs= d.keySet().iterator(); attrs.hasNext(); )
		pageContext.removeAttribute((String)attrs.next(), PageContext.REQUEST_SCOPE);
}

%>
<% // parade footers
for(Iterator cols=Config.getColumns("parade.footers"); cols.hasNext(); ){
%>
	<jsp:include flush="false" page="<%=cols.next()+\".jsp\" %>" />
<%
}
%>
</table>
</body>
</html>

