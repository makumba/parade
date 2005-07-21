package org.makumba.parade;

public class LoggingManager {

    /**
     * record an access made
     * 
     * @param data
     *            is empty
     * @param pc
     *            is a page context fabricated by LoginFilter. getRequest(),
     *            getResponse(), getSession(), getServletContext() are original
     *            though
     */
    public static void accessMade(java.util.Map data,
            javax.servlet.jsp.PageContext pc) throws java.io.IOException {
        // instead of printing this stupid message, this method should invoke a
        // logger configured in parade.properties
        javax.servlet.http.HttpServletRequest req = (javax.servlet.http.HttpServletRequest) pc
                .getRequest();
        // we take away dummy printing. auto-refreshed pages like tipoftheday
        // should be ignored anyway.
        // System.out.println(req.getRemoteUser()+" " +req.getServletPath());
    }

}
