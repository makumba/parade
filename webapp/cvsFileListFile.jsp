<%-- $Header$ --%>
<td><% if(pageContext.findAttribute("cvs.dir")==null) return; 
String cvscommand="<a target='command' href=command.jsp?"+pageContext.findAttribute("parade.sameDir")+"&entry="+java.net.URLEncoder.encode((String)pageContext.findAttribute("file.name"))+"&op=cvs&cvs.op=";
String cvscommitt="<a target='command' href=cvsCommit.jsp?reload=&"+pageContext.findAttribute("parade.sameDir")+"&entry="+java.net.URLEncoder.encode((String)pageContext.findAttribute("file.name"));
Integer status= (Integer)pageContext.findAttribute("cvs.status");
boolean onDisk=(pageContext.findAttribute("file.file")!=null);
String cvsweb="http://cvs.makumba.org/cgi-bin/cvsweb.cgi/"; //this should go to 
String cvswebLink=cvsweb+pageContext.findAttribute("cvs.module")+"/"+pageContext.findAttribute("file.path")+pageContext.findAttribute("file.name");

if(status==null) {%><%=onDisk?"":"<!--"%>
<% if( ((String)pageContext.findAttribute("file.name")).startsWith(".#") ) { %>
<a title="Backup of your working file, can be deleted once you resolved its conflicts with CVS">Conflict Backup</a>
<% } else { // show options to add to cvs%>
<%=cvscommand%>add&reload=><img src="images/cvs-add.gif" alt="add" border="0"></a>
<%=cvscommand%>add&cvs.op.-kb=&reload=><img src="images/cvs-add-binary.gif" alt="add binary" border="0"></a>
<% } %>
<%=onDisk?"":"-->"%>
<% return; }
switch(status.intValue()){
case 101:{ // IGNORED %>
<i><font size=-2><font color="#999999"><i>ignored</i></font></font></i>
<%} break;
case -1:{ // UNKNOWN %>
???
<%} break;
case 100:{ // UP_TO_DATE %>
<a href="<%=cvswebLink%>" title="CVS log"><%=pageContext.findAttribute("cvs.revision")%></a>
<%} break;
case 1:{ // LOCALLY_MODIFIED %>
<a href="<%=cvswebLink%>" title="CVS log"><%=pageContext.findAttribute("cvs.revision")%></a>
<%=cvscommitt%>><img src="images/cvs-committ.gif" alt="CVS committ" border="0"></a>
<%=cvscommand%>diff><img src="images/cvs-diff.gif" alt="CVS diff" border="0"></a>
<%} break;
case 2:{ // NEEDS_CHECKOUT %>
<a href="<%=cvswebLink%>" title="CVS log"><%=pageContext.findAttribute("cvs.revision")%></a>
<%=cvscommand%>update&reload=><img src="images/cvs-update.gif" alt="CVS checkout" border="0"></a>
<%=cvscommand%>delete&reload=><img src="images/cvs-remove.gif" alt="CVS remove" border="0"></a>
<%} break;
case 3:{ // NEEDS_UPDATE %>
<a href="<%=cvswebLink%>" title="CVS log"><%=pageContext.findAttribute("cvs.revision")%></a>
<%=cvscommand%>update&reload=><img src="images/cvs-update.gif" alt="CVS update" border="0"></a>
<%} break;
case 4:{ // ADDED %>
<%=pageContext.findAttribute("cvs.revision")%>
<%=cvscommitt%>><img src="images/cvs-committ.gif" alt="CVS committ" border="0"></a>
<%} break;
case 5:{ // DELETED %>
<a href="<%=cvswebLink%>" title="CVS log"><%=pageContext.findAttribute("cvs.revision")%></a>
<%=cvscommitt%>><img src="images/cvs-committ.gif" alt="CVS committ" border="0"></a>
<%} break;
case 6:{ // CONFLICT %>
<a href="<%=cvswebLink%>" title="CVS log"><b><font color="red">Conflict</font></b> <%=pageContext.findAttribute("cvs.revision")%></a>
<%=cvscommitt%>><img src="images/cvs-committ.gif" alt="CVS committ" border="0"></a>
<%=cvscommand%>diff><img src="images/cvs-diff.gif" alt="CVS diff" border="0"></a>
<%} break;
}
%>

