<% /* $Header$ */ %>
<%@ page import="org.makumba.parade.*, java.util.*" %>
<%
String context=request.getParameterValues("context")[0];
try{ 
String t;
String commandDomain="parade";
%>
<%t=Config.startPage(commandDomain, pageContext);%><%=t%>
<%
// reload check
if(t==null) return;
} catch(ParadeException e)
{
	out.println(e.getMessage());
}
pageContext.setAttribute("parade.row", context, PageContext.REQUEST_SCOPE);

    Map paradeRow = (Map)Config.invokeOperation("parade", "setParade", pageContext).get(context);	

    pageContext.setAttribute("parade.rowData", paradeRow, PageContext.REQUEST_SCOPE);
    for(Iterator i= paradeRow.entrySet().iterator(); i.hasNext();)
      {
	Map.Entry me= (Map.Entry)i.next();
	pageContext.setAttribute((String)me.getKey(), me.getValue(), javax.servlet.jsp.PageContext.REQUEST_SCOPE);
      }
%>
<html>
<head>
<title><%=context%> heading</title>
<base target="command">
<style type="text/css">
A {font-decoration:none}
</style>
</head>
<body bgcolor="#cccccc" TOPMARGIN=0 LEFTMARGIN=0 RIGHTMARGIN=0 BOTTOMMARGIN=0 marginwidth=0 marginheight=0 STYLE="margin: 0px">
<img src="images/win-x.gif" align=right alt="remove frames" border=0 hspace=1 vspace=1 onMouseDown="src='images/win-x2.gif'" 
onMouseUp="src='images/win-x.gif'; top.location=top.directory.location;">

<table border=0 cellspacing=0 cellpadding=0>
<form ACTION="browse.jsp" TARGET="_top" style="margin:0px;">
<tr><td valign=top>
<a HREF="." TARGET="_top" title="back to front page">&lt;</a>
<select SIZE="1" NAME="context" onChange="javascript:form.submit();">

<%
List orderedResult= new ArrayList();
Map data=null;
try{
	orderedResult.addAll((data=Config.invokeOperation("parade", "setParade", pageContext)).values());
}catch(ParadeException e)
	{ out.println("error during reading data "+e); return; }
Collections.sort(orderedResult, new MapComparator(request, "parade.row"));
for(Iterator dt= orderedResult.iterator(); dt.hasNext(); )
{
   Map row= (Map)dt.next();
   String name= (String)row.get("parade.row");
   String displayName=name;
   if(displayName.length()==0)
	displayName="(root)";
%>
<option VALUE="<%=name%>"<%=name.equals((String)context)?" selected":""%>><%=displayName%></option>
<% } // for
%>
</select><input TYPE="submit" VALUE="Go!">
</td>
</form>

<%// headers
for(Iterator cols=Config.getColumns("heading.buttons"); cols.hasNext(); ){
	%><td valign=top><jsp:include flush="false" page="<%=cols.next()+\".jsp\" %>" />&nbsp;</td><%
}
%>
</tr>
</table>
</body>
</html>