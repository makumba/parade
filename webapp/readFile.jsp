<% /* $Header$ */ 
%><%@ page import="org.makumba.parade.*, java.util.*, java.io.*" 
%><%@ taglib uri="http://www.makumba.org/presentation" prefix="mak" %><% 
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

response.setContentType("text/plain");
response.getOutputStream().print(content);
%>