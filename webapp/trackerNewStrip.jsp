<%-- $Header$ --%>
<%
String context=request.getParameterValues("context")[0];

if(org.makumba.parade.TrackerManager.getTrackerBase(pageContext)!=null)
{
String path="";
if(request.getParameterValues("path")!=null)
	path=request.getParameterValues("path")[0];
if(path.startsWith("/"))
	path=path.substring(1);
if(!path.endsWith("/"))
	path=path=path+"/";
String trackBase=org.makumba.parade.TrackerManager.getTrackerBase(pageContext);
  if(path.startsWith(trackBase)) { %>
<form action="trackerNew.jsp">
<input type=hidden value="<%=path.substring(trackBase.length()+1)%>" name=path>
<input type=hidden value="<%=context%>" name=context>

<input type=hidden name=page value="enter/path/file.here">
Track nonexisting file:<input type=text name=userentry>
<input type=submit value=Describe onClick="javascript:page.value=path.value+userentry.value;">
</form><%
  } //proper path
} //trackbase!=null %>