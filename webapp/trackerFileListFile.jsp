<%-- $Header$ --%>
<td>
<%
String trackBase="";
trackBase=org.makumba.parade.TrackerManager.getTrackerBase(pageContext);
String fileName="";
 
fileName=((String)pageContext.findAttribute("file.path"));
fileName=fileName+pageContext.findAttribute("file.name");

%><%
if(trackBase!=null) 
if( ((String)pageContext.findAttribute("file.path")).indexOf(trackBase)!=0 ) 
{
  %><font color="#999999">no tracker here</font><% 
} else 
{ 
    fileName=fileName.substring(trackBase.length()+1);
    if( pageContext.findAttribute("tracker.tracked")==null || ((String)pageContext.findAttribute("tracker.tracked")).equals("no") ) 
    { 
	%><font color="#999999"><i>Not <a href="trackerNew.jsp?page=<%=fileName%>" title="start tracking it">track</a>ed</i></font><%
    } else
    {
	if(pageContext.findAttribute("tracker.tracked").equals("yes")) 
	{
	    %><a href='trackerEdit.jsp?page=<%=pageContext.findAttribute("tracker.ptr")%>'
	      title='<%=((String)pageContext.findAttribute("tracker.description")).replace('\'','"')
	      %>'><%=((String)pageContext.findAttribute("tracker.title")).length()>0?pageContext.findAttribute("tracker.title"):"[no name]"%></a><% 
	} else
	{%><font color="#999999"><i>No Connection</i></font><% 
	} 
    }
}
else
{
  %><font color="#999999">no tracker here</font><%
} %>
