<%-- $Header$ --%>

<td><% if(pageContext.findAttribute("cvs.user")==null)
	return;
%><%=pageContext.findAttribute("cvs.user")%>,<b><%=pageContext.findAttribute("cvs.module")%></b>,<%=pageContext.findAttribute("cvs.branch")%>
