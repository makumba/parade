<%-- $Header$ --%>
<%@ taglib uri="http://www.makumba.org/presentation" prefix="mak" %>

<td><%
String trackBase="";
trackBase=org.makumba.parade.TrackerManager.getTrackerBase(pageContext);
String fileName="";

fileName=((String)pageContext.findAttribute("file.path"));
fileName=fileName+pageContext.findAttribute("file.name");
String title=(String)pageContext.findAttribute("tracker.title");
String description=(String)pageContext.findAttribute("tracker.description");
Object ptr=pageContext.findAttribute("tracker.ptr");
Object tracked=pageContext.findAttribute("tracker.tracked");

if(trackBase!=null)
if( fileName.equals(trackBase) )
{ %><font color="red"> tracker base</font><%
} else if(fileName.indexOf(trackBase)==0 )
{
    //fileName=fileName.substring(trackBase.length()+1);
    if( tracked==null || tracked.equals("no") )
    {
        %><font color="#999999"><i>Not <a href="trackerNew.jsp?page=<%=fileName.equals(trackBase)?"":fileName.substring(trackBase.length()+1)+"/"%>" 
title="start tracking it">track</a>ed</i></font><%
    } else
    {
        if(tracked.equals("yes") || ( tracked.equals("containsTracked") && title!=null))
        {
            %><a href='trackerEdit.jsp?page=<%=pageContext.findAttribute("tracker.ptr")%>'
              title='<%=description.replace('\'','"')
              %>'><%=title.length()>0?title:"[no name]"%></a><%

        } else if(tracked.equals("containsTracked"))
        {
	 %><font color="#999999"><i>Contains <a 
href="trackerNew.jsp?page=<%=fileName.equals(trackBase)?"":fileName.substring(trackBase.length()+1)+"/"%>" 
title="describe this folder">track</a>ed items</i></font><%
        } else 
        {%><font color="#999999"><i><i>No DB Connection</i></font><%
        }
    }
} else 
{
  %><font color="#999999">no tracker here</font><%
} 
else
{
  %><font color="#999999">no tracker here</font><%
} %>

