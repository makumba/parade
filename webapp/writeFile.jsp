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
%>done
