package org.makumba.parade;
import javax.servlet.*;
import javax.servlet.http.*;
import java.net.*;
import java.io.*;
import org.eu.best.tools.*;

public class InitServlet extends HttpServlet
{
  ServletContext context;
  public void init(ServletConfig conf)
  {
    context=conf.getServletContext();
    
    
    new Thread(new Runnable(){
      public void run(){ initialize(); }
    }).start();
  }
  
  public void initialize()
  {
    System.out.println("init: Starting Parade initialization at "+ new java.util.Date());
    System.out.flush();
    try{
      Config.invokeOperation("parade", "setParade", new PageContextDummy(){
	public ServletRequest getRequest()
	  { 
	    return new HttpServletRequestDummy(){
		public String getServerName(){ return "localhost"; }
		public int getServerPort(){ 
		  return Integer.parseInt(Config.getProperty("http.port").trim()); 
		}
		public String getPathInfo() { return "/index.jsp"; }
		public String getContextPath() { return ""; }
		
	    };
	  }
      });
    }catch(ParadeException pe) { pe.printStackTrace(); }
    catch(Throwable t){ t.printStackTrace(); }
    System.out.println("init: Parade finished initializing at   "+ new java.util.Date());
  }
}

