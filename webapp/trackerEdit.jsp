<% /* $Header$ */ %>
<%@ taglib uri="http://www.makumba.org/presentation" prefix="mak" %>
<ajsp:include page="header.jsp?title=Edit page" flush="false"/>
<% String referer=request.getHeader("Referer"); %>
<mak:object from="org.makumba.devel.PageInfo p" where="p.page=$page or p=$page" 
db='<%=org.makumba.parade.Config.getProperty("tracker.DB")%>' >
<h1>Editing info about /<mak:value expr="p.page"/></a></h1>


<mak:editForm object="p" action="<%=referer%>" method="POST" message="updated">

<table>
	<tr><td>Page:<td> /<mak:input field="page" size="50"/>
	<tr><td>Descriptive title:<td><mak:input field="title" size="50"/> 	
	<tr><td>Category:<td><mak:input field="category"/>	
	<tr><td>Status:<td><mak:input field="status"/>	
	<tr><td valign=top>Description:<td><mak:input field="description" rows="20" cols="60"/>	
	<tr><td>Author:<td> <mak:input field="author"/>
</table>

<input type=submit value="Update">
</mak:editForm>

<a href="<%=referer%>">back</a>
|
<mak:deleteLink object="p" action="<%=referer%>" message="deleted file info">Delete this</mak:deleteLink> 
(careful! If you're not sure just mark status as dropped instead.)


<p><font size=-2>Info created: <mak:value expr="p.TS_create"/>
<br>Last modified: <mak:value expr="p.TS_modify"/></font>
</mak:object>

<ajsp:include page="footer.jsp" flush="false"/>
