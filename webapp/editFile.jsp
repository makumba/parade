<% /* $Header$ */ %>
<%@ page import="org.makumba.parade.*, java.util.*, java.io.*" %>
<%@ taglib uri="http://www.makumba.org/presentation" prefix="mak" %>

<% 
String context=request.getParameterValues("context")[0];

String path="";
if(request.getParameterValues("path")!=null)
	path=request.getParameterValues("path")[0];

String file="";
if(request.getParameterValues("file")!=null)
	file=request.getParameterValues("file")[0];

String contextRoot;
Map data=null; 
try{
   data= (Map)Config.invokeOperation("parade", "setParade", pageContext).get(context);
   //Map row= (Map)data.get("parade.row");
   contextRoot= (String)data.get("parade.path");
}catch(ParadeException e)
	{ out.println("error during reading data "+e); return; }

//String contextRoot=((Long)pageContext.findAttribute("file.size")).longValue();
	
File f= new File(contextRoot+File.separator+path+file);
File d;
String content="";
String [] src=pageContext.getRequest().getParameterValues("source");
if(src!=null)
   {
      content=src[0];
      // we save
      if(f.getParent()!=null){
	d= new File(f.getParent());
	d.mkdirs();} 
      f.createNewFile();
      boolean windows=System.getProperty("line.separator").length()>1;
      PrintWriter pw= new PrintWriter(new BufferedWriter(new FileWriter(f)));
	for(int i=0; i<content.length(); i++)
	{
	   if(windows || content.charAt(i)!='\r')	
	           pw.print(content.charAt(i)); 			
	}

      pw.close();
   }
else
   {
	// we read the file
	if(f.exists())
	   {
		Reader rd= new BufferedReader(new FileReader(f));
		int c;
		StringBuffer sb=new StringBuffer();
		while((c=rd.read())!=-1)
		  sb.append((char)c);
		content=sb.toString();
           }
   }
StringBuffer sb=new StringBuffer();
for(int i=0; i<content.length(); i++)
   if(content.charAt(i)=='<') sb.append("&lt;"); 
   else if(content.charAt(i)=='&') sb.append("&amp;"); 
   else sb.append(content.charAt(i));
content=sb.toString();
%>
<html>
<head>
<title><%=file %> - parade editor</title>
<SCRIPT LANGUAGE="Javascript1.2">
<!--
function insert() {
strSelection = document.selection.createRange().text 
if (strSelection == "") { 
 	document.sourceEdit.source.selection.createRange().text =  strSelection + document.makHelper;
	return false; 
} 
else document.selection.createRange().text = "<b>" + strSelection 
+ "</b>" 
return;


}

// Javascript code for automatically resizing textarea
// Written by David W. Jeske and contributed to the public domain.

function onResize() {
  resizeTA(document.sourceEdit.source);
}

function resizeTA(TA) {
  var winW, winH;
  var usingIE = 0;

  // these paramaters have to match the font you specify with your
  // style tag on the textarea.
  var fontMetricWidth = 7;
  var fontMetricHeight = 14;

  // you don't want this smaller than 1,1
  var minWidthInCols = 20;
  var minHeightInRows = 7;

  // offset fudge factors. 
  // Making these bigger makes the textarea smaller.
  var leftOffsetFudge = 40;
  var topOffsetFudge = 20;


  if (parseInt(navigator.appVersion)>3) {
    if (navigator.appName=="Netscape") {
      winW = window.innerWidth;
      winH = window.innerHeight; 
    }
    if (navigator.appName.indexOf("Microsoft")!=-1) {
      winW = document.body.offsetWidth;
      winH = document.body.offsetHeight;
      usingIE = 1;
    }
  }

  if (! usingIE ) {
    return; // this javascript below does not work for netscape
  }

  // this code computes the upper-left corner offset
  // by walking all the elements in the html page  
  toffset = 0;
  loffset = 0;
  offsetobj = TA;
  while (offsetobj) {
    toffset += offsetobj.offsetTop + offsetobj.clientTop;
    loffset += offsetobj.offsetLeft + offsetobj.clientLeft;
    offsetobj = offsetobj.offsetParent;
  }

  // compute and set the width
  var overhead = loffset + leftOffsetFudge;
  var ta_width = ((winW - overhead))  / fontMetricWidth;
  if (ta_width < minWidthInCols) {
    ta_width = minWidthInCols;
  }
  TA.cols = ta_width;


  // compute and set the height
  var overhead = toffset + topOffsetFudge;
  var ta_height = (winH - overhead) / fontMetricHeight;
  if (ta_height < minHeightInRows) {
    ta_height = minHeightInRows;
  }
  TA.rows = ta_height;
}

function onLoad() {
  onResize();
  document.sourceEdit.source.focus();
  document.sourceEdit.pagestatus.value='Loaded.';
  document.sourceEdit.Submit.disabled=true;
}

<%-- http://www.webreference.com/dhtml/diner/beforeunload/bunload4.html --%>
function unloadMess(){
    mess = "You have unsaved changes."
    return mess;
}

function setBunload(on){
    window.onbeforeunload = (on) ? unloadMess : null;
}

/* to be called when the content of the big textarea changes*/
function setModified(){
    document.sourceEdit.pagestatus.value='MODIFIED';
    document.sourceEdit.Submit.disabled=false;
    setBunload(true);
}

//-->
</SCRIPT>

</head>
<body
bgcolor="#dddddd" TOPMARGIN=0 LEFTMARGIN=0 RIGHTMARGIN=0 BOTTOMMARGIN=0 marginwidth=0 marginheight=0 STYLE="margin: 0px" 
onload="javascript:onLoad();" onresize="javascript:onResize();">
<form name="sourceEdit" method="post" action="editFile.jsp?context=<%=context%>&path=<%=path%>&file=<%=file%>" style="margin:0px;">

<input type="submit" name="Submit" value="(S)ave!" ACCESSKEY="S" disabled onclick="javascript:setBunload(false);">
<a href="browse.jsp?context=<%=context%>" target="_top" title="<%=contextRoot%>"><%=context.equals("")?"(root)":context%></a
>:<a href="files.jsp?context=<%=context%>&path=<%=path.length()>1?path.substring(0,path.length()-1):""%>"><%=path%></a
><b><%=file%></b>
<%--   <a href="<%=context%><%=File.separator%><%=path%><%=file%>">Execute</a>
| <a href="<%=context%><%=File.separator%><%=path%><%=file%>x">Highlight</a>--%>
| <a href="editFile.jsp?context=<%=context%>&path=<%=path%>&file=<%=file%>" title="get the file from disk again, undo all changes since last save">Revert</a> 
| <input type="text" value="Loading..." name="pagestatus" disabled size="10" style="border:0px; background-color:#dddddd; font-color:red;">
<%--| <a href="list.jsp">Page tracker</a>--%>
| <a href="javascript:window.open('editFileApplet.jsp?context=<%=java.net.URLEncoder.encode(request.getParameterValues("context")[0])
%>&file=<%=java.net.URLEncoder.encode(request.getParameterValues("file")[0])
%>&path=<%=java.net.URLEncoder.encode(request.getParameterValues("path")[0])%>','editAppletWindow','status=1,toolbar=0,menubar=0,resizable=1')" title="try the new Applet editor">Applet editor</a>

|
<a href="editFileApplet.jsp?context=<%=java.net.URLEncoder.encode(request.getParameterValues("context")[0])
%>&file=<%=java.net.URLEncoder.encode(request.getParameterValues("file")[0])
%>&path=<%=java.net.URLEncoder.encode(request.getParameterValues("path")[0])%>" title="try the new Applet editor">Applet editor</a>

<%-- String descOuter=""; 
   String registered="no"; %>
<mak:object from="org.makumba.devel.PageInfo p" where="p.page=$path+$file">
| <a href="pageInfoEdit.jsp?page=<mak:attribute name="file"/>">&quot;<mak:value expr="p.title"/>&quot; by
<mak:value expr="p.author"/></a>
<mak:value expr="p.description" html="false" var="desc"/>
<% descOuter=desc.toString();
   registered="yes"; %>
</mak:object>
<% if(registered.equals("no")) { %>
| <a href="pageInfoNew.jsp?page=<mak:attribute name="file"/>">REGISTER this page</a>
<% } --%>
<br>

<textarea name="source" style="width:100%;height:92%" cols="90" rows="23" wrap="virtual"
onKeypress="setModified()"
STYLE="font-face:Lucida Console; font-size:8pt"><%=content%></textarea>

<!-- &nbsp; mak:<select name="makHelper" size="1">
<option value='<mak:logout actor=""/>'>logout</option>
</select><input type=button value="insert" onclick="javascript:insert();">
-->

<%--if(descOuter!=null && descOuter.toString().trim()!="") { %>
<br><font color=#22cc22><font size=-1><%=descOuter%><br></font></font>
<% } --%>
<%
String row="";
if(request.getParameterValues("row")!=null)
	row=request.getParameterValues("row")[0];

String col="";
if(request.getParameterValues("col")!=null)
	col=request.getParameterValues("col")[0];
%>
<input name="row" type="hidden" value="<%=row%>" >
<input name="col" type="hidden" value="<%=col%>" >
</form>
</body>
</html>
