package org.makumba.parade;
import java.util.ArrayList;
import java.util.Dictionary;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Vector;

import org.makumba.Database;
import org.makumba.MakumbaError;
import org.makumba.MakumbaSystem;
import org.makumba.Pointer;

public class TrackerManager
{

  // find the tracker base, it might be different later
  static public String getTrackerBase(javax.servlet.jsp.PageContext
			pc)
  {
      return (String)pc.findAttribute("servletContext.path");
  } 

  static Database db;
    static{
      try{
	  db= MakumbaSystem.getConnectionTo(Config.getProperty("tracker.DB"));
      }catch(Throwable t){ System.out.println("could not instantiate parade tracker db"+ " "+t.getMessage()); }
    }

  public void readFiles(java.util.Map data, javax.servlet.jsp.PageContext
			pc)
  {
   
    for(Iterator i= data.values().iterator(); i.hasNext(); )
	((Map)i.next()).put("tracker.tracked", "no");

    if(db==null)
	return;
    String trackerBase= getTrackerBase(pc);
    if(trackerBase==null)
       return;
    if(!trackerBase.endsWith("/"))
       trackerBase=trackerBase+("/");
    if(!trackerBase.equals("public_html/"))
       return;
    String filePath=(String)pc.findAttribute("file.path");
    
    if(!filePath.startsWith(trackerBase))
      return;
    
    filePath= filePath.substring(trackerBase.length());

    Vector v= null;
    Vector param= new Vector();
    param.add(filePath+"%");
    //param.add(filePath+"%/%");

    try{
      //v=MakumbaSystem.findDatabase().executeQuery("SELECT p as ptr, p.page as page, p.title as title FROM org.makumba.devel.PageInfo p where p.page LIKE $1 AND (p.page NOT LIKE $2)",param);
      v=db.executeQuery("SELECT p as ptr, p.page as page, p.title as title, p.description as description, p.author as author FROM org.makumba.devel.PageInfo p where p.page LIKE $1",param);
    }catch(MakumbaError e)
      { 
	pc.setAttribute("makumba.error", e,
			javax.servlet.jsp.PageContext.REQUEST_SCOPE); 

	// set tracker status to error
	for(Iterator i= data.values().iterator(); i.hasNext(); )
	  ((Map)i.next()).put("tracker.tracked", "error");

	return;
      }
    
    for(Enumeration e= v.elements(); e.hasMoreElements(); )
      {
	Dictionary d= (Dictionary)e.nextElement();
	Pointer ptr=(Pointer)d.get("ptr");
	String title=(String)d.get("title");
	if(title==null) title="(no name)";
	org.makumba.Text dText=(org.makumba.Text)d.get("description");
	String description="";
	if(dText!=null)
	   description=dText.toString();
	String author=(String)d.get("author");
	if(author==null) author="";
	String page=(String)d.get("page");
	String origPage=page;
	page=page.substring(filePath.length());
	int slash= page.indexOf('/');
	boolean isFile= slash==-1;
	String filename=isFile?page:page.substring(0, slash);
	
	Map row= (Map)data.get(filename);
	
	if(row==null)
	  { 
            //skip description of current folder:   
            //System.out.println(origPage+"="+filePath);
		if(origPage.equals(filePath))
		{
                  continue;   
                } 

	    /*we have a file which is in tracker but not on disk (because
	      FileManager has already ran) */
	    
	    row= new HashMap();
	    data.put(filename, row);
	    row.put("file.name", filename);
	    
	    // this is actually not needed, because if file.file is missing
	    // it's clear that the file doesn't exist
	    row.put("file.notOnDisk", "true");

	    // folder
	    if(!isFile)
	      row.put("isFolder", "true");
	    
	  }

 

	// for all filez, on disk or not, we set the tracker info
	if(isFile || slash==page.length()-1)
	  {
	    row.put("tracker.tracked", "yes");
	    row.put("tracker.ptr", ptr.toExternalForm());
	    row.put("tracker.description", description);
	    if(title.lastIndexOf(']')==title.length()-1 || author.length()==0) //some titles contain author info in "title [author]" format
	      row.put("tracker.title", title);
	    else
	      row.put("tracker.title", title+" ["+author+"]");
	  }
	else
	  {
	    row.put("tracker.tracked", "containsTracked");
	    if(!isFile && slash==page.length()-1) //folder
		{
	            row.put("tracker.ptr", ptr.toExternalForm());
		    row.put("tracker.description", description);
		    if(title.lastIndexOf(']')==title.length()-1 || author.length()==0) //some titles contain author info in "title [author]" format
		      row.put("tracker.title", title);
		    else
		      row.put("tracker.title", title+" ["+author+"]");
		} 
	  }
      } // for  
  } // method


  public void readTree(java.util.Map data, javax.servlet.jsp.PageContext
			pc)
  {
    String trackerBase= getTrackerBase(pc);
    if(trackerBase==null || db==null)
       return;
    if(!trackerBase.endsWith("/"))
       trackerBase=trackerBase+("/");
    if(!trackerBase.equals("public_html/"))
       return;
    String filePath=(String)pc.findAttribute("file.path");

    String root="";
    if(filePath.startsWith(trackerBase))
      root= filePath.substring(trackerBase.length());
    
    Vector v=null;
    try{
      //v=MakumbaSystem.findDatabase().executeQuery("SELECT p as ptr, p.page as page, p.title as title FROM org.makumba.devel.PageInfo p where p.page LIKE $1 AND (p.page NOT LIKE $2)",param);
      v=db.executeQuery("SELECT p.page as page FROM org.makumba.devel.PageInfo p where p.page LIKE $1", root+"%");
    }catch(MakumbaError e)
      { 
	pc.setAttribute("makumba.error", e,
			javax.servlet.jsp.PageContext.REQUEST_SCOPE); 
	return;
      }
    
    for(Enumeration e= v.elements(); e.hasMoreElements(); )
      {
	Dictionary d= (Dictionary)e.nextElement();
	String page=trackerBase+(String)d.get("page");
	String s=page;
	int n;
	while((n= s.lastIndexOf('/'))!=-1)
	  {
	    String dir= s.substring(0, n+1);
	    Map row= (Map)data.get(dir);
	    if(row==null)
	      {
		row= new HashMap();
		data.put(dir, row);
		row.put("file.path", dir);
		row.put("isFolder", "yes");
		row.put("file.notOnDisk", "true");
		String fl= s.substring(0, n);
		n=fl.lastIndexOf('/');
		if(n!=-1)
		  fl=fl.substring(n+1);
		row.put("file.name", fl);
		row.put("file.children", new ArrayList());
	      }
	    s=s.substring(0, n);
	  }
      }
  } // method
} // class
