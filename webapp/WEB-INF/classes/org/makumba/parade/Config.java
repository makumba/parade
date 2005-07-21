package org.makumba.parade;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;

import org.makumba.HtmlUtils;

/** the entrance to the Parade features */
public class Config {
    static public String paradeBase = "." + File.separator;

    static public String paradeBaseRelativeToTomcatWebapps = ".."
            + File.separator + "..";

    static Properties config;

    static HashMap managerLists = new HashMap();

    static HashMap columnLists = new HashMap();

    static HashMap managers = new HashMap();

    static HashMap methods = new HashMap();

    static String fileName = paradeBase + "parade.properties";

    static {
        try {
            config = new Properties();
            config.load(new FileInputStream(fileName));
        } catch (IOException e) {
            throw new RuntimeException(e.getMessage());
        }
    }

    /** read a configuration property from parade.properties */
    public static String getProperty(String configProperty) {
        return config.getProperty(configProperty);
    }

    /**
     * iterate thru the list of manager objects given by a configuration
     * property e.g. parade.managers= org.makumba.parade.xxx...,
     */
    public static Iterator getManagers(String configProperty) {
        return list(managerLists, ManagerProducer.singleton, configProperty);
    }

    /**
     * iterate thru the list of column names given by a configuration property
     * e.g. parade.columns= name, path, cvs, etc
     */
    public static Iterator getColumns(String s) {
        return list(columnLists, Producer.singleton, s);
    }

    /**
     * read the data of a domain the read<domainname> operation is invoked
     */
    public static Map readDomainData(String domain, PageContext pc)
            throws ParadeException {
        Map data = new HashMap();
        invokeOperation(data, domain,
                "read" + Character.toUpperCase(domain.charAt(0))
                        + domain.substring(1), pc);
        return data;
    }

    /**
     * invoke an operation on a parade domain <domainname>.managers should be
     * defined first, readDomainData is called then the operation as such is
     * invoked on the obtained data
     */
    public static Map invokeOperation(String domain, String operationName,
            PageContext pc) throws ParadeException {
        Map data;
        invokeOperation(data = readDomainData(domain, pc), domain,
                operationName, pc);
        return data;
    }

    static Map empty = new HashMap(1);

    /**
     * respond to a form. this will result in invoking an operation taken from
     * the "op" form parameter <domainname>.managers should be defined first,
     * the data is obtained, and filtered with the "entry" http parameter then
     * the operation indicated by "op" is called
     */
    public static String startPage(String domain, PageContext pc)
            throws ParadeException, javax.servlet.ServletException, IOException {
        String responseText = "";

        // first we check if there is something in the reload log file, and if yes, we add it to the response
        File f = new File(ServletContextManager.reloadLog);
        if (f.exists()) {
            BufferedReader fr = new BufferedReader(new FileReader(f));
            String s;
            while ((s = fr.readLine()) != null)
                responseText += s;
            fr.close();
            f.delete();
        }

        // identify the operation
        String[] ops = pc.getRequest().getParameterValues("op");
        if (ops == null)
            return responseText;
        if (ops.length != 1)
            throw new ParadeException("multiple operations not permitted");

        // compute the data for the operation
        Map data = readDomainData(domain, pc);
        Map originalData = data;

        String[] s = pc.getRequest().getParameterValues("entry");
        if (s != null) {
            Map data1 = new HashMap();
            for (int i = 0; i < s.length; i++) {
                Map m = (Map) data.get(s[i]);
                if (m != null)
                    data1.put(s[i], m);
                else
                    throw new ParadeException("data not found for " + s[i]);
            }
            data = data1;
        }
        
        // invoke the operation
        invokeOperation(data, domain, ops[0], pc);

        // read the result
        String separator = "";
        for (Iterator i = data.entrySet().iterator(); i.hasNext();) {
            Map.Entry entry = (Map.Entry) i.next();
            Map responseRow = (Map) entry.getValue();
            Integer n = (Integer) responseRow.get("reload");
            if (n != null) {
                pc.setAttribute("reload", n, PageContext.REQUEST_SCOPE);
                pc.forward(getProperty(domain + ".reloadPage"));
                return null;
            }
            Object resp = responseRow.get("result");
            if (resp != null) {
                responseText += separator + resp;
                separator = "<br>";
            }
        }
        return responseText;
    }

    /**
     * the core invokeOperation method, called by all other methods for all
     * managers the following methods are looked for and called:
     * <operationName>(Map allData, PageContext pc) <operationName>Simple(Map
     * oneRow, PageContext pc)
     */
    static public void invokeOperation(Map data, String domain,
            String operationName, PageContext pc) throws ParadeException {
        Object[] args = { data, pc };
        Object o;
        int n = 0;
        
        // invoke the operation for all managers
        for (Iterator i = getManagers(domain + ".managers"); i.hasNext();)
            n += invoke(getMethod(o = i.next(), operationName), o, args);

        // invoke the "operationSimple" for all managers and data elements
        String opSimple = operationName + "Simple";
        for (Iterator j = data.values().iterator(); j.hasNext();) {
            args[0] = j.next();
            for (Iterator i = getManagers(domain + ".managers"); i.hasNext();)
                n += invoke(getMethod(o = i.next(), opSimple), o, args);
        }
        if (n == 0 && data.size() > 0)
            throw new ParadeException("No manager supports operation "
                    + operationName);
    }

    /** elementary invocation of a method for one object */
    static int invoke(Method m, Object o, Object[] args) throws ParadeException {
        if (m != null)
            try {
                // long l= new Date().getTime();
                m.invoke(o, args);
                // System.out.println(""+(new Date().getTime()-l)+" "+m);
                return 1;
            } catch (InvocationTargetException ite) {
                Throwable e = ite.getTargetException();
                if (e instanceof ParadeException)
                    throw (ParadeException) e;
                throw new org.makumba.util.RuntimeWrappedException(e);
            } catch (Exception e) {
                throw new org.makumba.util.RuntimeWrappedException(e);
            }
        else
            return 0;
    }

    static Iterator list(HashMap map, Producer p, String s) {
        synchronized (map) {
            Object o = map.get(s);
            if (o == null) {
                ArrayList v = new ArrayList();
                map.put(s, v);
                if (config.getProperty(s) != null) {
                    StringTokenizer st = new StringTokenizer(config
                            .getProperty(s), ",");
                    while (st.hasMoreTokens())
                        v.add(p.produce(st.nextToken()));
                }
            }
        }
        return ((ArrayList) map.get(s)).iterator();
    }

    public static Object getManager(String classname) {
        String cl = classname.trim();
        synchronized (managers) {
            Object manager = managers.get(cl);
            if (manager == null) {
                try {
                    manager = Config.class.getClassLoader().loadClass(cl)
                            .newInstance();
                } catch (Throwable e) {
                    throw new RuntimeException("could not load class " + cl
                            + " " + e.getMessage());
                }
                managers.put(cl, manager);
            }
            return manager;
        }
    }

    static Class[] opArgs = { Map.class, PageContext.class };

    public static Method getMethod(Object o, String name)
            throws ParadeException {
        String s = o.getClass().getName() + "." + name;
        synchronized (methods) {
            Object method = methods.get(s);
            if (method == null) {
                try {
                    method = o.getClass().getMethod(name, opArgs);
                } catch (Exception e) {
                    method = "nothing";
                    // System.out.println(e+" "+o.getClass()+" "+name);
                }
                methods.put(s, method);
            }
            if (method.equals("nothing"))
                return null;
            return (Method) method;
        }
    }

    /** Format byte size in nice format. */
    public static String readableBytes(long byteSize) {
        if (byteSize < 0l)
            return ("invalid");
        if (byteSize < 1l)
            return ("empty");

        float byteSizeF = (new java.lang.Float(byteSize)).floatValue();
        String unit = "bytes";
        float factor = 1f;
        String[] desc = { "B", "kB", "MB", "GB", "TB" };

        java.text.DecimalFormat nf = new java.text.DecimalFormat();
        nf.setMaximumFractionDigits(1);
        nf.setGroupingUsed(true);

        String value = nf.format(byteSizeF);

        int i = 0;
        while (i + 1 < desc.length
                && (value.length() > 4 || (value.length() > 3 && value
                        .indexOf('.') < 0))) {
            i++;
            factor = factor * 1024l;
            value = nf.format(byteSizeF / factor);
        }
        if (value.charAt(0) == '0' && i > 0) { // go one back if a too-big
            // scale is used
            value = nf.format(java.lang.Math.round(1024 * byteSizeF / factor));
            i--;
        }

        if (value.length() > 3 && value.indexOf('.') > 0) // sut decimals on
            // large numbers
            value = value.substring(0, value.indexOf('.'));

        unit = desc[i];
        return (value + " " + unit);
    }

    /** lentgh of time periods in nice format. */
    public static String readableTime(long milis) {
        // simplest implementation:
        // return((new Long(secs)).toString())+" seconds";
        long secs = milis / 1000l;

        if (secs < 2l)
            return ("1 second");
        if (secs == 2l)
            return ("2 seconds");

        // default:
        long value = secs; // new Long(secs);
        String unit = "seconds";

        // now try to give it a meaning:
        Long s = new Long(secs);

        long[] breaks = { 31536000, 2628000, 604800, 86400, 3600, 60, 1 };
        String[] desc = { "year", "month", "week", "day", "hour", "minute",
                "second" };

        int i = 0;
        while (i <= breaks.length && secs <= (2 * breaks[i])) {
            i++;
        }
        // i=i-1;
        // long break=breaks[i];
        value = secs / breaks[i];
        unit = desc[i];
        if (value >= 2)
            unit = unit + "s";

        String retval = value + " " + unit;

        // if...

        return (retval);
    }

    public static PrintStream getPrintStream(JspWriter out) {
        final JspWriter o = out;
        return new PrintStream(new ByteArrayOutputStream()) {
            void process(String s) throws IOException {
                o.print(s);
            }

            void process(byte[] buffer, int start, int len) throws IOException {
                process(HtmlUtils.string2html(new String(buffer, start, len)));
            }

            public void write(byte[] buffer, int start, int len) {
                try {
                    int lastStart = start;
                    for (int i = start; i < start + len; i++) {
                        if (buffer[i] == '\n') {
                            process(buffer, lastStart, i - lastStart);
                            process("<br>\n");
                            o.flush();
                            lastStart = i + 1;
                        }
                    }
                    if (lastStart < start + len)
                        process(buffer, lastStart, start + len - lastStart);
                } catch (IOException ioe) {
                    throw new RuntimeException(ioe.toString());
                }
            }
        };
    }

    public static PrintStream getPrintStreamCVS(JspWriter out) {
        final JspWriter o = out;
        return new PrintStream(new ByteArrayOutputStream()) {
            public void print(String s) {
                try {
                    o.print(s);
                } catch (Throwable t) {
                    t.printStackTrace();
                }
            }

            public void println(String s) {
                try {
                    String style = "color:#444444"; // default
                    if (s.startsWith("M "))
                        style = "color:blue"; // modified
                    if (s.startsWith("A "))
                        style = "color:purple"; // added
                    if (s.startsWith("R "))
                        style = "color:purple"; // removed
                    if (s.startsWith("U "))
                        style = "color:green"; // updated
                    if (s.startsWith("P "))
                        style = "color:green"; // patched
                    if (s.startsWith("C "))
                        style = "color:red; font:bold"; // conflict
                    if (s.startsWith("? "))
                        style = "color:purple"; // unknown
                    if (s.startsWith("< "))
                        style = "background:#ffdddd"; // content removed
                    if (s.startsWith("> "))
                        style = "background:lightblue"; // content added
                    if (s.startsWith("exec: "))
                        style = "color:black";
                    if (s.startsWith("cvs server: "))
                        style = style;
                    if (s.endsWith("was lost"))
                        style = "color: brown; background:pink";
                    if (s.endsWith(" -- ignored"))
                        style = "color: green";
                    o.println("<span style=\"" + style + "\">"
                            + HtmlUtils.string2html(s) + "</span><br>");
                    o.flush();
                } catch (Throwable t) {
                    t.printStackTrace();
                }
            }
        };
    }

    public static int exec(Vector v, File dir, PrintStream ps) {
        String command = "";
        String[] cmd = new String[v.size()];
        String sep = "";
        for (int i = 0; i < cmd.length; i++) {
            cmd[i] = (String) v.elementAt(i);
            command += sep;
            sep = " ";
            if (cmd[i].indexOf(' ') != -1)
                command += "\"" + cmd[i] + "\"";
            else
                command += cmd[i];
        }
        ps.println("exec: cd " + dir);
        ps.println("exec: " + command);
        Date start = new Date();

        Process p1;
        try {
            p1 = Runtime.getRuntime().exec(cmd, null, dir);
        } catch (IOException e) {
            ps.println(e);
            return -1;
        }

        final Process p = p1;
        final PrintStream ps1 = ps;
        new Thread(new Runnable() {
            public void run() {
                flushTo(new BufferedReader(new InputStreamReader(p
                        .getErrorStream()), 81960), ps1);
            }
        }).start();

        flushTo(new BufferedReader(new InputStreamReader(p.getInputStream()),
                81960), ps);

        try {
            p.waitFor();
        } catch (InterruptedException e) {
            return -1;
        }
        int ret = p.exitValue();
        ps.println("exec: exit value: " + ret);
        ps.println("exec: elapsed time: "
                + (new Date().getTime() - start.getTime()) + " ms");
        return ret;
    }

    public static void flushTo(BufferedReader r, PrintStream o) {
        String s;
        try {
            while ((s = r.readLine()) != null)
                o.println(s);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void addCommandOptions(Vector v, String prefix,
            javax.servlet.jsp.PageContext pc) {
        for (Enumeration e = pc.getRequest().getParameterNames(); e
                .hasMoreElements();) {
            String s = (String) e.nextElement();
            if (!s.startsWith(prefix + ".-"))
                continue;
            v.addElement(s.substring(prefix.length() + 1));
            s = pc.getRequest().getParameterValues(s)[0];
            if (s.indexOf(' ') != -1)
                s = "\"" + s + "\"";
            if (s.length() > 0)
                v.addElement(s);
        }
    }

    public static void debug(Object s, PageContext pc) {
        try {
            pc.getOut().print(s);
            pc.getOut().print("<br>");
        } catch (IOException e) {
        }
    }

    public static synchronized void reloadLoggingConfig() {
        String loggingFile = System
                .getProperty("java.util.logging.config.file");
        if (loggingFile == null)
            return;
        File f = new File(loggingFile);

        long l = f.lastModified();
        long loggingFileDate = -1l;
        String lfd = System.getProperty("org.makumba.parade.loggingFileDate");
        if (lfd != null)
            loggingFileDate = Long.parseLong(lfd);
        if (loggingFileDate < l) {
            String old = org.makumba.parade.tools.PerThreadPrintStream.get();
            org.makumba.parade.tools.PerThreadPrintStream.set("logging");
            if (lfd != null)
                System.out.println(new java.util.Date()
                        + " reloading logger configuration");
            try {

                Properties p = new Properties();
                p.load(new FileInputStream(f));
                for (Enumeration e = p.keys(); e.hasMoreElements();) {
                    String s = (String) e.nextElement();
                    if (s.startsWith("org.makumba.parade-context")
                            && s.endsWith(".level")) {
                        java.util.logging.Logger.getLogger(s.substring(0, s
                                .length() - 6));
                    }
                }
                java.util.logging.LogManager.getLogManager()
                        .readConfiguration();
                for (Enumeration e = p.keys(); e.hasMoreElements();) {
                    String s = (String) e.nextElement();
                    if (s.startsWith("org.makumba.parade-context")
                            && s.endsWith(".level"))
                        System.out.println("<" + s + "> set to <" + p.get(s)
                                + ">");
                }
            } catch (IOException ioe) {
                throw new RuntimeException(ioe.toString());
            }
            org.makumba.parade.tools.PerThreadPrintStream.set(old);
        }
        System.setProperty("org.makumba.parade.loggingFileDate", "" + l);
    }

    /**
     * CVSweb.cgi (perl): 2329 ## 2330 # print readable timestamp in terms of
     * 2331 # '..time ago' 2332 # H. Zeller <zeller@think.de> 2333 ## 2334 sub
     * readableTime ($$) 2335 { 2336 my ($i, $break, $retval); 2337 my
     * ($secs,$long) =
     * 
     * @_; 2338 2339 # this function works correct for time >= 2 seconds 2340 if
     *     ($secs < 2) { 2341 return "very little time"; 2342 } 2343 2344 my
     *     %desc = (1 , 'second', 2345 60, 'minute', 2346 3600, 'hour', 2347
     *     86400, 'day', 2348 604800, 'week', 2349 2628000, 'month', 2350
     *     31536000, 'year'); 2351 my
     * @breaks = sort {$a <=> $b} keys %desc; 2352 $i = 0; 2353 while ($i <=
     *         $#breaks && $secs >= 2 * $breaks[$i]) { 2354 $i++; 2355 } 2356
     *         $i--; 2357 $break = $breaks[$i]; 2358 $retval = plural_write(int
     *         ($secs / $break), $desc{"$break"}); 2359 2360 if ($long == 1 &&
     *         $i > 0) { 2361 my $rest = $secs % $break; 2362 $i--; 2363 $break =
     *         $breaks[$i]; 2364 my $resttime = plural_write(int ($rest /
     *         $break), 2365 $desc{"$break"}); 2366 if ($resttime) { 2367
     *         $retval = $retval . ", " . $resttime; 2368 } 2369 } 2370 2371
     *         return $retval; 2372 } 2373
     * 
     */

}

class Producer {
    static Producer singleton = new Producer();

    Object produce(String s) {
        return s.trim();
    }
}

class ManagerProducer extends Producer {
    static ManagerProducer singleton = new ManagerProducer();

    Object produce(String s) {
        return Config.getManager(s.trim());
    }
}
