<%-- $Header$ --%>

<% String context=request.getParameterValues("context")[0]; %>

<HTML>
<HEAD>
<TITLE><%=context.length()==0?"(root)":context%> browser</TITLE>
</HEAD>

<FRAMESET rows="30,*">      
   <FRAME name="header" src="heading.jsp?context=<%=context%>" marginwidth="1" marginheight="1">
   <FRAMESET cols="190,*">
      <FRAME name="tree" src="tree.jsp?context=<%=context%>" marginwidth="0" marginheight="5">
      <FRAMESET rows="*,20%">      
          <FRAME name="directory" src="files.jsp?context=<%=context%>">
          <FRAME name="command" src="tipOfTheDay.jsp" marginwidth="1" marginheight="1">
      </FRAMESET>
   </FRAMESET>
</FRAMESET>



<%-- we rely on frames for now...
<NOFRAMES>
      <P>This frameset document contains:
      <UL>
         <LI><A href="tree.jsp">directory tree</A>
         <LI><A href="files.jsp">directory content</A>
      </UL>
</NOFRAMES>
--%>

</HTML>
