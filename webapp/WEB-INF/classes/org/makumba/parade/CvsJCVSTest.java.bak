/**  cristi: tried a bit of jCVS but with not much success
 * the jcvs lib is poorly documented, but I think it can be done 
 * by looking at sources (especially look how the jCVS UI uses the 
 * com.ice.cvsc, which is the connection to CVS.
 * http://www.jcvs.org/
 * http://www.gjt.org/javadoc/com/ice/cvsc/
 * To test this, you will need the com.ice.cvss classes in CLASSPATH. 
 * I put a jar of them at http://devel.best.eu.org/itc/bundle-unpacked/util-java/lib/cvsc.jar
 * you can test this one with ant -find build.xml -Dcvspass=yourCVSPass jcvstest
 */
package org.makumba.parade;
import com.ice.cvsc.*;
import java.io.*;

public class CvsJCVSTest
{
  public static void main(String argv[]) throws IOException
  {
    CVSClient cvs= new CVSClient();
    //cvs.setHostName("malaka.best.eu.org");
    //cvs.setPort(2401);
    CVSRequest req= new CVSRequest();
    req.setEntries(new CVSEntryVector());
    String path= new File(".").getCanonicalPath();
    CVSProject proj= new CVSProject();
    String pass= CVSScramble.scramblePassword(argv[0], 'A');
    proj.setPassword(pass);
    proj.setClient(cvs);
    
    // this seems to connect to CVS succesfully
    proj.openProject(new File("."));
    System.out.println("opened");    

    // from here on, something it wrong
    req.setCommand("-n update -l");
    CVSResponse resp= new CVSResponse(); 

    // it blocks here
    proj.performCVSRequest(req, resp);

    System.out.println("performed");
    System.out.println(resp.getStderr());
    System.out.println(resp.getStdout());

  }
}
