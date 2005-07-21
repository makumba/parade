package org.makumba.parade;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

public class LocalRowStore {
    File stateFile = new File(Config.paradeBase + "rowstore.properties");

    Properties state;

    public void readParade(java.util.Map data, javax.servlet.jsp.PageContext pc) {
        readState(pc);

        for (Enumeration e = state.keys(); e.hasMoreElements();) {
            String key = (String) e.nextElement();
            if (!key.startsWith("rowdata."))
                writePath(data, key);
        }
    }

    void writePath(Map data, String name) {
        Map m = (Map) data.get(name);
        if (m == null) {
            m = new HashMap();
            data.put(name, m);
        }
        m.put("parade.row", name);
        try {
            m.put("parade.path", new File(state.getProperty(name).trim())
                    .getCanonicalPath());
        } catch (IOException ioe) {
            throw new RuntimeException(ioe.getMessage());
        }

        String propName = "rowdata." + name + ".";
        for (Enumeration e = state.keys(); e.hasMoreElements();) {
            String key = (String) e.nextElement();

            if (key.startsWith(propName))
                m.put("parade." + key.substring(propName.length()), state
                        .get(key));
        }

    }

    synchronized void readState(javax.servlet.jsp.PageContext pc) {
        state = new Properties();
        try {
            if (stateFile.exists())
                state.load(new FileInputStream(stateFile));
            else {
                String contextPath = ((javax.servlet.http.HttpServletRequest) pc
                        .getRequest()).getContextPath();

                state.put(contextPath, Config.paradeBase);
                state.save(new FileOutputStream(stateFile), "rows");
            }
        } catch (IOException e) {
            throw new RuntimeException(e.getMessage());
        }
    }

    public synchronized void addParadeRow(java.util.Map data,
            javax.servlet.jsp.PageContext pc) throws ParadeException {
        String s[] = pc.getRequest().getParameterValues("parade.row");
        if (s == null || s.length != 1 || s[0].trim().indexOf(" ") != -1)
            throw new ParadeException(
                    "missing name, multiple names, or name containing spaces");
        String rowName = s[0].trim();
        Map row = new HashMap();
        data.put(rowName, row);
        row.put("parade.name", rowName);

        Config.invokeOperation(data, "parade", "findPath", pc);
        String path = (String) row.get("parade.path");
        if (path == null)
            throw new ParadeException("could not determine path");

        state.put(rowName, path);
        try {
            state.save(new FileOutputStream(stateFile), "rows");
        } catch (IOException e) {
            throw new ParadeException("could not save state: " + e);
        }
    }
}
