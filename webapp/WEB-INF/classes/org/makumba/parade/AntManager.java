package org.makumba.parade;
import java.util.Map;
import java.util.*;
import org.apache.tools.ant.*;
import java.io.*;


public class AntManager
{
  Map buildFileCache= new HashMap();

  public void setParadeSimple(Map row, javax.servlet.jsp.PageContext pc)
  {
    setBuildFile(row);
    if(row.get("ant.project")==null) 
      return;
    setTargets(row);
  }

  public void setBuildFile(Map row)
  {
    String filePath= "build.xml";
    File dir= new File((String)row.get("parade.path"));
    
    File buildFile=new File(dir, "build.xml");
    if(!buildFile.exists())
      return;
    row.put("ant.file", buildFile);
    row.put("ant.filePath", filePath);
    getProject(buildFile, row);
  }
  
  synchronized void getProject(File buildFile, Map row)
  {
    Object[]o= (Object[])buildFileCache.get(buildFile.getAbsolutePath());
    if(o==null || buildFile.lastModified()>((Long)o[0]).longValue())
      {
	buildFileCache.put(buildFile.getAbsolutePath(), o= new Object[3]);
	o[0]= new Long(buildFile.lastModified());
	Project project=new Project();
	o[1]=project;
	
	try{
	  project.init();
	  ProjectHelper.configureProject(project, buildFile);
	}catch(Throwable t) 
	  { 
	    java.util.logging.Logger.getLogger("org.makumba.parade.ant").log(java.util.logging.Level.WARNING, "project config error", t); 
	    row.put("ant.error", t);
	    return;
	  }
	project.setUserProperty( "ant.file" , buildFile.getAbsolutePath());
	DefaultLogger lg= new DefaultLogger();
	lg.setEmacsMode(true);
	lg.setMessageOutputLevel(Project.MSG_INFO);
	o[2]=lg;
	project.addBuildListener(lg);

      }
    row.put("ant.project", o[1]);
    row.put("ant.logger", o[2]);
  }

  public void setTargets(java.util.Map row)
  {
    Project project=(Project)row.get("ant.project");
    Enumeration ptargets = project.getTargets().elements();

    ArrayList topTargets = new ArrayList();
    ArrayList subTargets= new ArrayList();

    while (ptargets.hasMoreElements()) {
      Target currentTarget = (Target)ptargets.nextElement();

      if (currentTarget.getDescription() == null) 
	subTargets.add(currentTarget.getName());
      else
	{
	  String obj[]= { currentTarget.getName(), currentTarget.getDescription()};
	  topTargets.add(obj);
	}
    }
    Collections.sort(subTargets);
    Collections.sort(topTargets, new Comparator()
		     {
		       public int compare(Object o1, Object o2)
			 { return ((String[])o1)[0].compareTo(((String[])o2)[0]); }
		     });
    row.put("ant.topTargets", topTargets);
    row.put("ant.subTargets", subTargets);
  }

  public void executeAntCommandSimple(java.util.Map row, javax.servlet.jsp.PageContext pc) throws IOException
  {
    java.lang.Runtime rt=java.lang.Runtime.getRuntime(); 
    rt.gc();
    long memSize=rt.totalMemory()-rt.freeMemory();
    setBuildFile(row);
    Project project=(Project)row.get("ant.project");
    DefaultLogger lg= (DefaultLogger)row.get("ant.logger");
    //    File temp= File.createTempFile("paradeAnt", "txt");
    final javax.servlet.jsp.PageContext pageContext=pc;
    PrintStream ps=Config.getPrintStream(pc.getOut());
    ps.println("heap size: "+ memSize);
    ps.println(Main.getAntVersion());
    ps.println("Buildfile: "+  row.get("ant.file"));
    String s[]=pc.getRequest().getParameterValues("antCommand");
    Vector v=new Vector();
    for(int i=0; i<s.length;i++)v.addElement(s[i]);

    synchronized(project)
      {
	lg.setOutputPrintStream(ps);
	lg.setErrorPrintStream(ps);
	
	lg.buildStarted(null);
	Throwable error=null;
	try{
	  project.executeTargets(v);
	}catch(Throwable t){ error=t; }
	BuildEvent be= new BuildEvent(project);
	be.setException(error);
	lg.buildFinished(be);
      }
    ps.flush();
    rt.gc();
    long memSize1=rt.totalMemory()-rt.freeMemory();
    ps.println("heap size: "+ memSize1);  
    ps.println("heap grew with: "+ (memSize1-memSize));
  }


}
