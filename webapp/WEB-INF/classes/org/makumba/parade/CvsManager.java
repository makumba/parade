package org.makumba.parade;
import java.util.*;
import java.text.*;
import java.io.*;

public class CvsManager
{
  public static DateFormat cvsDateFormat;
  static{
    cvsDateFormat= new SimpleDateFormat("EEE MMM dd HH:mm:ss yyyy", Locale.UK);
    cvsDateFormat.setTimeZone(TimeZone.getTimeZone("GMT"));
  }
  
  public void setParadeSimple(java.util.Map row, javax.servlet.jsp.PageContext pc)
  {
    readUserAndModule(row);
    // if(row.get("cvs.user")!=null)
    //  readStatus(row);
  }
  
  public void readUserAndModule(Map row)
  {
    String path= (String)row.get("parade.path");
    String s=null;
    try{
      s= new BufferedReader(new FileReader(path+File.separator+"CVS"+File.separator+"Root")).readLine();
    }catch(FileNotFoundException e){ return; }
    catch(IOException ioe){throw new RuntimeException(ioe.getMessage()); }
    
    if(!s.startsWith(":pserver"))
      row.put("cvs.user", "non :pserver");
    else
      {
	s= s.substring(":pserver:".length());
	row.put("cvs.user",s.substring(0, s.indexOf("@")));
      }
    
    try{
      s= new BufferedReader(new FileReader(path+File.separator+"CVS"+File.separator+"Repository")).readLine();
    }catch(IOException e){ throw new RuntimeException(e.getMessage()); }
    row.put("cvs.module", s.substring(s.lastIndexOf('/')+1));

    try{
      s="TMAIN";
      s= new BufferedReader(new FileReader(path+File.separator+"CVS"+File.separator+"Tag")).readLine();
    }catch(FileNotFoundException e){ }
    catch(IOException ioe){throw new RuntimeException(ioe.getMessage()); }
    row.put("cvs.branch", s.substring(1));

  }


  public void cvs(java.util.Map data, javax.servlet.jsp.PageContext pc)
  {
    Vector command= new Vector();
    command.addElement("cvs");
    Config.addCommandOptions(command, "cvs", pc);
    command.addElement(pc.getRequest().getParameterValues("cvs.op")[0]);
    Config.addCommandOptions(command, "cvs.op", pc);
    String mes[];
    if((mes=pc.getRequest().getParameterValues("cvs.committMessage"))!=null)
      {
	command.addElement("-m");
	command.addElement(mes[0]);
      }
    if(pc.getRequest().getParameterValues("cvs.perDir")==null)
      for(Iterator i= data.values().iterator(); i.hasNext(); )
	{
	  Map m = (Map)i.next();
	  command.addElement(m.get("file.name"));
	}
    Config.exec(command, (File)pc.findAttribute("file.baseFile"), Config.getPrintStreamCVS(pc.getOut()));
  }

  static Integer IGNORED=new Integer(101);
  static Integer UNKNOWN=new Integer(-1);
  static Integer UP_TO_DATE=new Integer(100);
  static Integer LOCALLY_MODIFIED=new Integer(1);
  static Integer NEEDS_CHECKOUT=new Integer(2);
  static Integer NEEDS_UPDATE=new Integer(3);
  static Integer ADDED=new Integer(4);
  static Integer DELETED=new Integer(5);
  static Integer CONFLICT=new Integer(6);

  public void readFiles(java.util.Map data, javax.servlet.jsp.PageContext pc)
       throws ParadeException
  {
    Map paradeRow= (Map)pc.findAttribute("parade.rowData");
    
    readCVSEntries(paradeRow, data, pc);
    readCVSIgnore(paradeRow, data, pc);
    //    readCVSCheckUpdate(paradeRow, data, pc);
  }

  public void readCVSEntries(java.util.Map paradeRow, java.util.Map data, javax.servlet.jsp.PageContext pc)
       throws ParadeException
  {
    File f=new File((paradeRow.get("parade.path")+"/"+paradeRow.get("file.path")+"CVS/Entries").replace('/', File.separatorChar));
    if(!f.exists())
      {
	paradeRow.put("cvs.dir", "no");
	pc.setAttribute("cvs.dir", "no", pc.REQUEST_SCOPE);
	return;
      }

    paradeRow.put("cvs.dir", "yes");
    pc.setAttribute("cvs.dir", "yes", pc.REQUEST_SCOPE);
    try{
      BufferedReader br= new BufferedReader(new FileReader(f));
      String line= null;
      while((line=br.readLine())!=null)
	{
	  if(line.startsWith("/"))
	    {
	      int n= line.indexOf('/', 1);
	      if(n==-1)
		continue;
	      String name= line.substring(1, n);
	      Map row= (Map)data.get(name);
	      if(row==null)
		{
		  row= new HashMap();
		  data.put(name, row);
		  row.put("file.name", name);
		  row.put("file.notOnDisk", "true");
		}
	      row.put("cvs.status", UNKNOWN);
	      line=line.substring(n+1);
	      n=  line.indexOf('/');
	      if(n==-1)
		continue;
	      String revision=line.substring(0, n);
	      row.put("cvs.revision", revision);
	      line=line.substring(n+1);
	      n=  line.indexOf('/');
	      if(n==-1)
		continue;

	      File fl=(File)row.get("file.file");

	      if(fl==null && !revision.startsWith("-"))
		{
		  row.put("cvs.status", NEEDS_CHECKOUT);
		  continue;
		}

	      String date=line.substring(0, n);

	      if(date.equals("Result of merge"))
		 {
		   row.put("cvs.status", LOCALLY_MODIFIED);
		   continue;
		 }

	      if(date.startsWith("Result of merge+"))
		 {
		   row.put("cvs.status", CONFLICT);
		   continue;
		 }

	      if(date.equals("dummy timestamp"))
		 {
		   row.put("cvs.status", revision.startsWith("-")?DELETED:ADDED);
		   continue;
		 }

	      Date fd=null;
	      try{
		row.put("cvs.date", fd=cvsDateFormat.parse(date));
	      }catch(ParseException e)
		{
		  System.out.println(e);
		  continue;
		}
	      
	      long cvsModified=fd.getTime();

	      long l=fl.lastModified()-cvsModified
		//-(TimeZone.getDefault().inDaylightTime(new Date(fl.lastModified()))?3600000:0);
		;
	      if(Math.abs(l)<1500 
		 // for some stupid reason, lastModified() is different in Windows than Unix
		 // the difference seems to have to do with daylight saving
		 || Math.abs(Math.abs(l)-3600000) < 1000
		 )
		{
		  row.put("cvs.status", UP_TO_DATE);
		  continue;
		}

	      row.put("cvs.status", l>0?LOCALLY_MODIFIED:NEEDS_UPDATE);
	      // stupid windows bug
	      //	      if(l<0)
	      // System.out.println(l);
	      continue;
	    }
	  else if(line.startsWith("D/"))
	    {
	      int n= line.indexOf('/', 2);
	      if(n==-1)
		continue;
	      String name= line.substring(2, n);
	      Map row= (Map)data.get(name);
	      if(row==null)
		{
		  row= new HashMap();
		  data.put(name, row);
		  row.put("file.name", name);
		  row.put("file.notOnDisk", "true");
		  row.put("isFolder", "yes");
		  row.put("cvs.status", NEEDS_CHECKOUT);
		}
	      else
		{
		  row.put("cvs.status", UP_TO_DATE);
		  row.put("cvs.revision", "(dir)");
		}
	    }
	}
      br.close();
    }catch(IOException e){ throw new ParadeException(e.getMessage()); }
  }

  public void readCVSIgnore(java.util.Map paradeRow, java.util.Map data, javax.servlet.jsp.PageContext pc)
       throws ParadeException
  {
    if(paradeRow.get("cvs.dir").equals("no"))
      return;
    File f=new File((paradeRow.get("parade.path")+"/"+paradeRow.get("file.path")+".cvsignore").replace('/', File.separatorChar));
    if(!f.exists())
      return;

    try{
      BufferedReader br= new BufferedReader(new FileReader(f));
      String line= null;
      while((line=br.readLine())!=null)
	{
	  line=line.trim();
	  Map row= (Map)data.get(line);
	  if(row==null)
	    continue;
	  row.put("cvs.status", IGNORED);
	}
      br.close();
    }catch(IOException e){ throw new ParadeException(e.getMessage()); }
  }

  public void readCVSCheckUpdate(java.util.Map paradeRow, java.util.Map data, javax.servlet.jsp.PageContext pc)
       throws ParadeException
  {
    Vector v=new Vector();
    v.addElement("cvs");
    v.addElement("-l");
    v.addElement("-n");
    v.addElement("update");
    v.addElement("-l");
    v.addElement("-d");
    v.addElement("-p");

    ByteArrayOutputStream bo= new ByteArrayOutputStream();
    //    if(Config.exec("cvs -n -l update -l -d -P", (File)pc.findAttribute("file.baseFile"),

    if(Config.exec(v, (File)pc.findAttribute("file.baseFile"),
		new PrintStream(bo))!=0)
      return;
    String s= new String(bo.toByteArray());
    StringTokenizer st= new StringTokenizer(s, "\n");
    while(st.hasMoreTokens())
      {
	s=st.nextToken().trim();
	if(s.startsWith("M "))
	  {
	    // take the file name and mark it as "locally modified"
	    // hmmm. all other files that seem locally modified but are not should be marked OK
	    continue;
	  }
	if(s.startsWith("U "))
	  {
	    // take the file name and mark it as "needs update"
	    continue;
	  }
	if(s.endsWith("was lost"))
	  {
	    // take the file name and mark it as "needs checkout"
	    continue;
	  }
      }
  }
}
