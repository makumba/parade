<%-- $Header$ --%>
<br>CVS: 
<%
String cvscommand="<a target='command' href=command.jsp?"+pageContext.findAttribute("parade.sameDir")+"&cvs.perDir=&op=cvs&cvs.op=";
%>
<%=cvscommand%>update&cvs.-l=&cvs.-n=&cvs.op.-d=&cvs.op.-P=>check status</a>
<%=cvscommand%>update&cvs.op.-d=&cvs.op.-P=&cvs.op.-l=&reload=>local update</a>
<%=cvscommand%>update&cvs.op.-d=&cvs.op.-P=&reload=>recursive update</a>
