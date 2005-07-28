<%@taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<html>

<% String context=request.getParameterValues("context")[0]; 
   if(context.equals("")) context="(root)";

   String user=(String)session.getAttribute("org.makumba.parade.user");
   String lastMessage=""+user+" just came to "+context;
%>
<HEAD>
<meta http-equiv="refresh" content="30;URL=messageTicker.jsp?context=">
<script language="javascript">
<!--
  //show last message in the browser window title
  top.document.title="<%=context%>: <%=lastMessage%>";
//-->
</script>
</HEAD>

<body>
<c:if test="${initParam['prototyping'] eq 'yes'}" >
<c:choose>
<c:when test="${param.to!=null}">
<form action="messageTicker.jsp?context=" method="post">
send message to <c:out value="${param.to}" />
<input type="text" name="msg" size="20">
<input type="hidden" name="to1" value="<c:out value="${param.to}"/>">
<input type="submit" value="Send!">

</form>
</c:when>
<c:otherwise>
<form action="messageTicker.jsp?context=" method="post">
<c:if test="${param.msg!=null}" >
<b><c:out value="${sessionScope['org.makumba.parade.user']}"/>
</b>
<c:choose>

<%
/*
<c:when test="${param.to1!=null}" >
  <c:out value="to ${param.to1}"/>
</c:when>
<c:otherwise>says</c:otherwise>
</c:choose>
: "<i><c:out value="${param.msg}"/></i>",
</c:if>
<jsp:useBean id="random" class="org.makumba.parade.RandomBean"/>
*/
%>
<jsp:setProperty name="random" property="alternative" value="<a href=\"messageTicker.jsp?to=cristi&context=\">cristi</a> is in (root), <a href=\"messageTicker.jsp?to=fred&context=\">fred</a> works on fred-k"/>

<jsp:setProperty name="random" property="alternative" value="<b>fred</b> says \"<i>did you see my latest johnny login?\"</i> <a href=\"messageTicker.jsp?to=cristi&context=\">cristi</a> is in (root), <a href=\"messageTicker.jsp?to=fred&context=\">fred</a> works on fred-k"/>

<jsp:setProperty name="random" property="alternative" value="<a href=\"messageTicker.jsp?to=cristi&context=\">cristi</a> is testing demo-k, <a href=\"messageTicker.jsp?to=fred&context=\">fred</a> has just reloaded fred-k, <a href=\"messageTicker.jsp?to=raul&context=\">raul</a> views demo-k sources"/>

<jsp:setProperty name="random" property="alternative" value="priit seems to have left. You are alone, but happy."/>

<jsp:getProperty  name="random" property="rnd" />
<input type="text" name="msg" size="20"><input type="submit" value="Say!">
</form>

</c:otherwise>
</c:choose>
</c:if>
</body>