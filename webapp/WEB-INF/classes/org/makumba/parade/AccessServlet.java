package org.makumba.parade;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import org.eu.best.tools.*;

/** The servlet called at the begining of each parade access, in all servlet contexts 
 * This servlet does: login, calls Config.reloadLoggingConfig for refreshing of logging.properties, and 
*/
public class AccessServlet extends HttpServlet
{
  ServletContext context;
  HttpLogin checker;
  boolean isMakumbaContext;

  public void init()
  {
    Object o= PerThreadPrintStream.class;
    context=getServletConfig().getServletContext(); 

    String authClass= Config.getProperty("parade.authorizerClass");
    String authMessage= Config.getProperty("parade.authorizationMessage");
    if(authClass==null)
      return;
    String db=Config.getProperty("parade.authorizationDB");
    try{
      Authorizer auth=(Authorizer)getClass().getClassLoader().loadClass(authClass).newInstance();
      if(db!=null && (auth instanceof DatabaseAuthorizer))
	((DatabaseAuthorizer)auth).setDatabase(db);
      checker= new HttpLogin(auth, authMessage)
	{
	  public boolean login(ServletRequest req, ServletResponse res)
	    throws java.io.IOException	
	    {
	      HttpServletRequest req1=(HttpServletRequest)req;
	      String user= (String)req1.getSession(true).getAttribute("org.makumba.parade.user");
	      return user!=null || super.login(req, res);
	    }  
	  
	  protected boolean checkAuth(String user, String pass, HttpServletRequest req)
	    {
	      boolean passes= super.checkAuth(user, pass, req);
	      if(passes)
		req.getSession(true).setAttribute("org.makumba.parade.user", user);
	      return passes;
	    }
	};
    }catch(Throwable t){ throw new RuntimeException("Error initializing the login authorizer: "+t); }
  }

  public void destroy(){}
  
  boolean shouldLogin(ServletRequest req)
  {
    if(checker==null)
      return false;
    String[] initkey= req.getParameterValues("initkey");
    if(initkey!=null && initkey[0].equals(context.getAttribute("org.makumba.parade.init")))
      return false;
    if(((HttpServletRequest)req).getContextPath().equals("/manager"))
      return false;
    return true;
  }

  HttpServletRequest checkLogin(ServletRequest req, ServletResponse resp) throws java.io.IOException
  {
    if(checker.login(req, (HttpServletResponse)req.getAttribute("org.eu.best.tools.TriggerFilter.response")))
      {
	return new HttpServletRequestWrapper((HttpServletRequest)req)
	  {
	    public String getRemoteUser()
	      { return (String)((HttpServletRequest)getRequest()).getSession(true).getAttribute("org.makumba.parade.user"); }
	  };
      }
    return null;
  }

  void setOutputPrefix(HttpServletRequest req, HttpServletResponse resp)
  {
    String contextPath=req.getContextPath();
    String contextPathOrig=contextPath;
    if(contextPath.equals(""))
      {
	contextPath="parade";
	contextPathOrig="/";
      }
    else
      contextPath=contextPath.substring(1);
    String nm=(String)req.getSession(true).getAttribute("org.makumba.parade.user");
    if(nm==null)
      nm="(unknown user)";
    PerThreadPrintStream.set(nm+"@"+contextPath);
    
    ServletContext ctx= (ServletContext)req.getAttribute("org.eu.best.tools.TriggerFilter.context");

    try{
      if(ctx.getResource("/WEB-INF/lib/makumba.jar")!=null)
	{
	  HttpServletRequest dummyRequest= (HttpServletRequest)req.getAttribute("org.eu.best.tools.TriggerFilter.dummyRequest");
	  dummyRequest.setAttribute("org.makumba.systemServlet.command", "setLoggingRoot");
	  dummyRequest.setAttribute("org.makumba.systemServlet.param1", "org.makumba.parade-context."+contextPath);
	  ctx.getRequestDispatcher("/servlet/org.makumba.devel.SystemServlet").include(dummyRequest, resp);
      }
    }catch(Throwable t){ t.printStackTrace(); }
  }

  public void service(ServletRequest req, ServletResponse resp) throws java.io.IOException, ServletException
  {
    
    HttpServletRequest origReq=(HttpServletRequest)req;
    req=(HttpServletRequest)req.getAttribute("org.eu.best.tools.TriggerFilter.request");
    Config.reloadLoggingConfig();
    setOutputPrefix((HttpServletRequest)req, (HttpServletResponse)resp);
    ServletRequest req1=req;
    if(!shouldLogin(req) || (req1=checkLogin(req, resp))!=null)
      {
	// we set the output prefix again, now that we know the user
	setOutputPrefix((HttpServletRequest)req, (HttpServletResponse)resp);
	origReq.setAttribute("org.eu.best.tools.TriggerFilter.request", req1);
      }
    else
      // login failed, we tell the trigger filter not to filter further
      origReq.removeAttribute("org.eu.best.tools.TriggerFilter.request");
      
  }
}
