<%-- $Header$ 
--%><%@ page import="java.util.*,org.makumba.parade.*" 
%><% if(pageContext.findAttribute("ant.project")==null) return;
String sep="";
for(Iterator i= ((Collection)pageContext.findAttribute("ant.topTargets")).iterator(); i.hasNext(); )
{
String s=((String[])i.next())[0];
for(Iterator j=Config.getColumns("ant.allowedOps"); j.hasNext(); )
{ 

	if(!s.equals(j.next()))
		continue;
%><%=sep%> <a href=paradeCommand.jsp?op=executeAntCommand&entry=<%=pageContext.findAttribute("parade.row")%>&antCommand=<%=s%> ><%=s%></a><%
sep=",";
}
}
for(Iterator i= ((Collection)pageContext.findAttribute("ant.subTargets")).iterator(); i.hasNext(); )
{
	String s=((String)i.next());
for(Iterator j=Config.getColumns("ant.allowedOps"); j.hasNext(); )
{ 
	if(!s.equals(j.next()))
		continue;
%><%=sep%> <a href=paradeCommand.jsp?op=executeAntCommand&entry=<%=pageContext.findAttribute("parade.row")%>&antCommand=<%=s%> ><%=s%></a><%
sep=",";
}
}
%>