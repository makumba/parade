<% /* $Header$ */ %>
<%@ page import="org.makumba.parade.*, java.util.*" %>
<%
String context=request.getParameterValues("context")[0];

//defaults:
String size="normal"; 
String fontSize="0.7em";
String imagePath="imagesCompact";
if(request.getParameterValues("size")!=null)
   { size=request.getParameterValues("size")[0];} 
if(size.toLowerCase().equals("big"))
   { 
     fontSize="1em";
     imagePath="images";
   }
%>
<html>
<head>
<title><%=context%> tree</title>
<style type="text/css">
A {
     color:black;
     text-decoration:none;
     font-family:Tahoma,Arial;
     font-size:<%=fontSize%>;
     <%--vertical-align:5px;--%>
}
A:active { 
     color:white;
     background:rgb(0,0,120);
}
</style>
</head>
<ajsp:include page="header.jsp?title=Browse files" flush="false"/>

<body>
<%
List orderedResult= new ArrayList();
Map data=null;
try{
	orderedResult.addAll((data=Config.invokeOperation("parade", "setParade", pageContext)).values());
}catch(ParadeException e)
	{ out.println("error during reading data "+e); return; }
Collections.sort(orderedResult, new MapComparator(request, "parade.row"));

%>
<%
    Map paradeRow = (Map)data.get(context);	
    pageContext.setAttribute("parade.rowData", paradeRow, PageContext.REQUEST_SCOPE);
    paradeRow.put("file.path", "");
    for(Iterator i= paradeRow.entrySet().iterator(); i.hasNext();)
      {
	Map.Entry me= (Map.Entry)i.next();
	pageContext.setAttribute((String)me.getKey(), me.getValue(), javax.servlet.jsp.PageContext.REQUEST_SCOPE);
      }
List tree= null;
try{	
tree=FileManager.setChildren(Config.readDomainData("tree", pageContext));
}catch(ParadeException e)
	{ out.println("error during reading data "+e); return; }

pageContext.setAttribute("tree.treeList", tree, PageContext.REQUEST_SCOPE);
%>
<%-- get a base (root) branch of this context, and recursively dig... might be problems with circular symlinks --%>

<%
String agent=request.getHeader("User-Agent");
if(agent.indexOf("Gecko")>0 || agent.indexOf("MSIE")>0 ) { //draw new-style tree with treeMenu%>
	<script src="treeMenu/sniffer.js"></script>
	<script src="treeMenu/TreeMenu.js"></script>
	
	<div id="menuLayer<%=context%>"></div>
<% if(size.equals("normal")) { %>
   <a href="tree.jsp?context=<%=context%>&size=big" title="Show bigger"><img src="images/magnify.gif" align="right" border="0"></a>
<% } else { %>
   <a href="tree.jsp?context=<%=context%>&size=normal" title="Show smaller"><img src="images/magnify.gif" align="right" 
border="0"></a>
<% } %>
<script language="javascript" type="text/javascript">
	objTreeMenu = new TreeMenu("menuLayer<%=context%>", "treeMenu/<%=imagePath%>", "objTreeMenu", "directory");
	objTreeMenu.n[0] = new TreeNode('<%=context.equals("")?"(root)":context%>', 'folder.gif', 'files.jsp?context=<%=context%>', false);
<jsp:include page="treeBranch.jsp">
	<jsp:param name="context" value="<%=context%>" />
	<jsp:param name="path" value="" />
	<jsp:param name="depth" value="0" />
	<jsp:param name="level" value="1" />
	<jsp:param name="treeMenu" value="bla" />
</jsp:include>
objTreeMenu.drawMenu();
objTreeMenu.resetBranches();
</script>

<% } // treeMenu
   else { // old-style tree %>
<pre><a href="files.jsp?context=<%=context%>" target="directory"><img src="images/tree-open.gif" border="0" align="absbottom" name="root"><%=context.equals("")?"(root)":context%></a
><jsp:include page="treeBranch.jsp">
	<jsp:param name="context" value="<%=context%>" />
	<jsp:param name="path" value="" />
	<jsp:param name="depth" value="" />
	<jsp:param name="level" value="0" />
</jsp:include>
</pre>

<% } // old Style tree%>

</body>
</html>

<%--
<script language="JavaScript">
<!--

function SwitchFolder(folder) {
	SetAllImages("images/tree-closed.gif");
	
		 
}

function SetAllImages(url) {
    len = document.images.length;
    var i = 0;
    for(i = 0; i < len; i++) {
        if (document.images[].name.length>2)document.images[i].src = url;
    }
}

//-->
</script>
--%> 
