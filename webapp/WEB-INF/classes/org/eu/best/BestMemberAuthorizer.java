package org.eu.best;
import java.util.Dictionary;
import java.util.Vector;

import org.makumba.Database;
import org.makumba.MakumbaSystem;
import org.makumba.parade.tools.DatabaseAuthorizer;

public class BestMemberAuthorizer extends DatabaseAuthorizer
{



 public boolean auth(String user, String pass) 
 {
    user= user.trim().toLowerCase();
    pass= pass.trim();

    if(user.equals("") || pass.equals(""))
    {
       MakumbaSystem.getLogger().finest("BestMemberAuthorizer: No username or password specified.");
       return false;
    }

    MakumbaSystem.getLogger().fine("BestMemberAuthorizer: Checking user: "+user);
    Database db= MakumbaSystem.getConnectionTo(getDatabase());

    Vector v;
    Object[] args= {user, pass, user.substring(0,1).toUpperCase()+user.substring(1)};
    try{
       v= db.executeQuery("SELECT s, s.student.person.name AS name, s.student.person.surname AS surname FROM best.internal.Student s WHERE (s.student.authentication.n_username=$1 OR s.student.authentication.shortname=$1 OR s.student.person.surname=$3 OR s.student.person.name=$3) AND s.student.authentication.n_password=$2", args);
    }finally { db.close(); }

    if(v.size()==1)
    { 
       //TODO make a better log entry here.
       String fullname=(String)((Dictionary)v.elementAt(0)).get("name")+" "+(String)((Dictionary)v.elementAt(0)).get("surname");
       MakumbaSystem.getLogger().info("BestMemberAuthorizer: User logged in: "+fullname);
       return true;       
    }
    else 
    {
       MakumbaSystem.getLogger().fine("BestMemberAuthorizer: User: \""+user+"\" failed to log in.");
       return false;
    }

  }


}
