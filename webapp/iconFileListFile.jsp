<%-- $Header$ --%>
<%
    String image="unknown";
    String fname= (String)pageContext.findAttribute("file.name");
    String fl=fname.toLowerCase();

    if(fl.endsWith(".java")) image="java"; 

    if(fl.endsWith("mdd") || fl.endsWith(".idd")) image="text"; 

    if(fl.endsWith(".jsp")||fl.endsWith(".properties") || fl.endsWith(".xml") || fl.endsWith(".txt") || fl.endsWith(".conf")) image="text";

    if(fl.endsWith(".doc")||fl.endsWith(".jsp")||fl.endsWith(".html") || fl.endsWith(".htm") || fl.endsWith(".rtf")) image="layout";

    if(fl.endsWith(".gif")||fl.endsWith(".png") || fl.endsWith(".jpg") || fl.endsWith(".jpeg")) image="image";

    if(fl.endsWith(".zip")||fl.endsWith(".gz") || fl.endsWith(".tgz") || fl.endsWith(".jar")) image="zip";

    if(fl.endsWith(".avi")||fl.endsWith(".mpg") || fl.endsWith(".mpeg") || fl.endsWith(".mov")) image="movie";

    if(fl.endsWith(".au")||fl.endsWith(".mid") || fl.endsWith(".vaw") || fl.endsWith(".mp3")) image="sound";

    if(pageContext.findAttribute("file.file")==null) image="broken";
%>
<td><img src="images/<%=image%>.gif" border="0"></td>
