<%-- $Header$ --%>
<%@ taglib uri="http://www.makumba.org/presentation" prefix="mak" %>
<th>Tracker <%
if(pageContext.findAttribute("makumba.response")!=null)
{
  if( request.getHeader("Referer") !=null && ((String)request.getHeader("Referer")).indexOf("tracker")>0) { %>
<%=pageContext.findAttribute("makumba.response")%>
<% } 
} 

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

<a href="trackerNew.jsp?context=<%=context%>&page=<%=path.substring(trackBase.length()+1)%>"><img src="images/newfile.gif" alt="new file" border=0></a>
<%
  } //proper path
} //trackbase!=null %>
