<%-- $Header$ --%>
<td><% String fname= (String)pageContext.findAttribute("file.name");
%>
<%--
<input type=checkbox name="files[]" value="<%=fname%>">
--%>
<a href="files.jsp?<%=pageContext.findAttribute("parade.sameDir")%><%=pageContext.findAttribute("file.name")%>/"><b><%=pageContext.findAttribute("file.name")%>/</b></a>
