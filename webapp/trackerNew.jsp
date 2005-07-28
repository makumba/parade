<% /* $Header$ */ %>
<%@ taglib uri="http://www.makumba.org/presentation" prefix="mak" %>
<% String referer=request.getHeader("Referer"); %>

<h2>Track new file</h2>
<mak:attribute name="page" var="pageStr" exceptionVar="blabla"/>
<% if(pageStr==null) {
	pageContext.setAttribute("page",".jsp");
     } %>

<mak:newForm type="org.makumba.devel.PageInfo"
	method="POST" action="<%=referer%>"
	message="registered new file"
	db='<%=org.makumba.parade.Config.getProperty("tracker.DB")%>'>
<table>
	<tr><td>Page:<td> http://thisServer/<mak:input
field="page" size="50" value="$page" dataType="char"/>
	<tr><td>Descriptive title:<td><mak:input field="title" size="50"/> 	
	<tr><td>Category:<td><mak:input field="category"/>	
	<tr><td>Status:<td><mak:input field="status"/>	
	<tr><td valign=top>Description:<td><mak:input field="description" rows="20" cols="60"/>	
	<tr><td>Author:<td> <mak:input field="author"/>
</table>
	
<input type=submit value="Add this page information">
</mak:newForm>

<a href="<%=referer%>">back to list</a>