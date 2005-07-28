<%-- $Header$ 
--%><%@ page import="org.makumba.parade.*, java.util.*, java.io.*" %><%
// we're sure these will exist. to be even more sure, we can pass them as request attributes
// no use for makumba for just passing arguments...
String context=request.getParameterValues("context")[0];
String path="";
if(request.getParameterValues("path")!=null)
	 path=request.getParameterValues("path")[0];
String depth="";
if(request.getParameterValues("depth")!=null)
	 depth=request.getParameterValues("depth")[0];
int level=0;
if(request.getParameterValues("level")!=null)
	level=(new Integer(request.getParameterValues("level")[0])).intValue();

//Integer(pageContext.getAttribute("treeLine",pageContext.REQUEST_SCOPE))
Integer treeLine=(Integer)(pageContext.getAttribute("treeLine",pageContext.REQUEST_SCOPE));
//try {
//	treeLine=(new Integer()).intValue();
//	} catch(java.lang.NumberFormatException e) {}
if(treeLine==null) treeLine=new Integer(0);

pageContext.setAttribute("parade.row", context, PageContext.REQUEST_SCOPE);

    Map paradeRow = (Map)pageContext.findAttribute("parade.rowData");
    paradeRow.put("file.path", path);

    pageContext.setAttribute("file.path", path, PageContext.REQUEST_SCOPE);

String fname="";
String treeRow="";

List tree= (List) pageContext.findAttribute("tree.treeList");
//now show filtered folders

if(request.getParameterValues("treeMenu")!=null) { //make output for treeMenu.js
int ctr=0;
for(Iterator j=tree.iterator();j.hasNext(); ctr++)
{ 
	Map row= (Map)j.next();
	pageContext.setAttribute("tree.treeList", (List)row.get("file.children"), PageContext.REQUEST_SCOPE);	
	fname=(String)row.get("file.name");
     
	depth=depth+","+ctr;//make last one different 
	level++;
	treeLine=new Integer(treeLine.intValue()+1);
	pageContext.setAttribute("treeLine", treeLine, pageContext.REQUEST_SCOPE);
    
	treeRow="objTreeMenu"; //start a javascript line to compose a tree

	StringTokenizer st = new StringTokenizer(depth,",");
	while (st.hasMoreTokens()) {
		treeRow=treeRow+".n["+st.nextToken()+"]";
		//println(st.nextToken());
	}

%><%=treeRow %> = new TreeNode('<%=fname%>', 'folder.gif', 'files.jsp?context=<%=context%>&path=<%=path%>/<%=fname%>', false);  
<% 
String subDir=path+'/'+fname;
	if(level<50) { //prevent infinite depth (because of symlinks)
%><jsp:include page="treeBranch.jsp">
	<jsp:param name="context" value="<%=context%>" />
	<jsp:param name="path" value="<%=subDir%>" />
	<jsp:param name="depth" value="<%=depth%>" />
	<jsp:param name="level" value="<%=level%>" />
	<jsp:param name="treeMenu" value="bla" />
	
</jsp:include><%		  }
		level--;
		depth=depth.substring(0,depth.lastIndexOf(','));
     
   } //for 


} else { //old-style tree made of images and links.
int ctr=0;
for(Iterator j=tree.iterator();j.hasNext(); ctr++)
{ 
	Map row= (Map)j.next();
	pageContext.setAttribute("tree.treeList", (List)row.get("file.children"), PageContext.REQUEST_SCOPE);	
	fname=(String)row.get("file.name");
     
	depth=depth+((ctr==(tree.size()-1))?"  ":" |"); //make last one different 
	level++;
	treeLine=new Integer(treeLine.intValue()+1);
	pageContext.setAttribute("treeLine", treeLine, pageContext.REQUEST_SCOPE);
    
	treeRow=""; //compose a tree out of images
	for(int i=0; i<depth.length();i=i+2)
	{
		if(depth.substring(i,i+2).equals("  "))  
			treeRow=treeRow+"<img src=\"images/tree-empty.gif\" border=\"0\" ALIGN=\"absbottom\" valign=\"absbottom\">";
		else  
			treeRow=treeRow+"<img src=\"images/tree-bar-right.gif\" border=\"0\" ALIGN=\"absbottom\" valign=\"absbottom\">";
	}
	/*	<img src="images/tree-leaf.gif">
	*/	
%>
<br><font color="#202090"><%=treeRow %><img src="images/tree-leaf.gif" ALIGN="absbottom" valign="absbottom"></font><a href="files.jsp?context=<%=context%>&path=<%=path%>/<%=fname%>" target="directory" 

><img src="images/tree-closed.gif" border="0" ALIGN="absbottom"><%=fname%></a><% 
String subDir=path+'/'+fname;
	if(level<50) { //prevent infinite depth (because of symlinks)
%><jsp:include page="treeBranch.jsp">
	<jsp:param name="context" value="<%=context%>" />
	<jsp:param name="path" value="<%=subDir%>" />
	<jsp:param name="depth" value="<%=depth%>" />
	<jsp:param name="level" value="<%=level%>" />
	
</jsp:include><%		  }
		level--;
		depth=depth.substring(0,depth.length()-2);
     
   } //for 
} // displaying tree of images and text
%>