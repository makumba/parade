<%-- $Id$ --%>
<%
String context=request.getParameterValues("context")[0];

String path="";
if(request.getParameterValues("path")!=null)
	path=request.getParameterValues("path")[0];
%>
<h3>New file in <%=(context.length()==0?"(root)":context)+(path.equals(java.io.File.separator)?"":java.io.File.separator)+path%></h3>
<jsp:include page="newFileStrip.jsp" flush="false"/>
<jsp:include page="uploadFileStrip.jsp" flush="false"/>

