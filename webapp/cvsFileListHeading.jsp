<%-- $Header$ --%>
<th><a href=files.jsp?<%=pageContext.findAttribute("parade.sameDir")%>&order=cvs.status>CVS<a><%
String cvscommand="<a target='command' href=command.jsp?"+pageContext.findAttribute("parade.sameDir")+"&cvs.perDir=&op=cvs&cvs.op=";
%><%=cvscommand%>update&cvs.-l=&cvs.-n=&cvs.op.-d=&cvs.op.-P= title="CVS check status"><img src="images/cvs-query.gif" alt="CVS check status" border="0"></a
><%=cvscommand%>update&cvs.op.-d=&cvs.op.-P=&cvs.op.-l=&reload= title="CVS local update"><img src="images/cvs-update.gif" alt="CVS local update" border="0"></a
><%=cvscommand%>update&cvs.op.-d=&cvs.op.-P=&reload= title="CVS recursive update"><img src="images/cvs-update.gif" alt="CVS recursive update" border="0"></a>