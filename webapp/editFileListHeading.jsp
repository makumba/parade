<%-- $Header$ --%>
<%-- <th> --%>
<script language="JavaScript">
<!-- 
function deleteFile(fileName) {
  if(confirm('Are you sure you want to\ndelete file '+fileName))
  {
	top.frames["command"].document.location.href='command.jsp?<%=pageContext.findAttribute("parade.sameDir")%>&entry='+fileName+'&op=deleteFile&commandDomain=files&reload=1'; 
  }
}

function editFileInApplet(fileName) {
   //test if editor already open
   if(parent.editAppletWindow!=null && !parent.editAppletWindow.closed)
   {
      parent.editAppletWindow.focus();
      samedir='<%=pageContext.findAttribute("parade.sameDir")%>';
      //alert("old window found!\n<%=pageContext.findAttribute("parade.sameDir")%>");
      context = samedir.substring(samedir.indexOf('=')+1,samedir.indexOf('&'));
      path = samedir.substring(samedir.lastIndexOf('=')+1);
      //alert(context+"..."+path);
      parent.editAppletWindow.openFile(context,path,fileName);
   } else {
      parent.editAppletWindow=window.open('editFileApplet.jsp?<%=pageContext.findAttribute("parade.sameDir")%>&file='+fileName,'editAppletWindow','status=1,toolbar=0,menubar=0,resizable=1');
      parent.editAppletWindow.focus();
   }
}

// -->
</script>

<%
 String context=request.getParameterValues("context")[0];

String path="";
if(request.getParameterValues("path")!=null)
        path=request.getParameterValues("path")[0];
if(path.startsWith("/"))
        path=path.substring(1);
if(!path.endsWith("/"))
        path=path=path+"/";
%>
<a href="newUploadFile.jsp?context=<%=context%>&path=<%=path%>" target="command"><img src="images/newfile.gif" alt="new file" border=0></a>

