<%-- $Header$ 
--%>
<td><% String fname= (String)pageContext.findAttribute("file.name");
%>
<input type=checkbox name="files[]" value="<%=fname%>">
<%
   String path=(String)pageContext.findAttribute("file.path");
   String addr="";
   String ctxPath=(String)pageContext.findAttribute("servletContext.path");
   String ctx=null;
   // makumba viewers should actually move here
   if(ctxPath!=null 
    && ((Integer)pageContext.findAttribute("servletContext.status")).intValue()==org.makumba.parade.ServletContainer.RUNNING  
    && path.startsWith(ctxPath)
    && pageContext.findAttribute("file.file")!=null )
 	{
         String fl=fname.toLowerCase();
	ctx= (String)pageContext.findAttribute("servletContext.name");
	if(ctx.length()>1)
		ctx=ctx+"/";

        if(fl.endsWith(".java"))
             {
                   String dd=path+fname;
                   dd=dd.substring(dd.indexOf("classes")+8, dd.lastIndexOf(".")).replace('/', '.');
                   addr="classes/"+dd;
              }

        if(fl.endsWith(".mdd") || fl.endsWith(".idd"))
             {
                   String dd=path+fname;
                   dd=dd.substring(dd.indexOf("dataDefinitions")+16, dd.lastIndexOf(".")).replace('/', '.');
                   addr="dataDefinitions/"+dd;
              }

        if(fl.endsWith(".jsp")||fl.endsWith(".html") || fl.endsWith(".htm") || fl.endsWith(".txt") || fl.endsWith(".gif") || fl.endsWith(".png") || fl.endsWith(".jpeg") || fl.endsWith(".jpg") || fl.endsWith(".css") || fl.startsWith("readme") )
		addr=path.substring(ctxPath.length()+1)+fname;

	if(fl.endsWith(".jsp"))
		addr+="x";
	}

if(!addr.equals("")) { %><a href="<%=ctx%><%=addr%>"><%=fname%></a><% }
else { //rest of the files
               %><%=fname%><%
          }
%>
