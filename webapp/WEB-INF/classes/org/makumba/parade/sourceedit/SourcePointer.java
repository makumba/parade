package org.makumba.parade.sourceedit;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.Observable;

/** a (possibly remote) pointer to a source file hosted in a Parade */
public class SourcePointer extends Observable {
    URL u;

    String context, path, file;

    boolean contentChanged;

    // file content
    String content;

    // save status; set but not used
    String saveStatus;

    public SourcePointer(URL u, String context, String path, String file) {
        this.u = u;
        this.context = context;
        this.path = path;
        this.file = file;
        load();
    }

    public String getText() {
        return content;
    }

    public String getHashString() {
        return u + "#" + context + "#" + path + "#" + file;
    }

    public boolean getChanged() {
        return contentChanged;
    }

    public void change(String s) {
        if (content.equals(s))
            return;
        content = s;
        if (!contentChanged) {
            contentChanged = true;
            setChanged();
            notifyObservers(this);
        }
    }

    /** return the current content */
    public String getContent() {
        return content;
    }

    /** load the source file from parade */
    public synchronized void load() {
        try {
            InputStream is = (InputStream) (new URL(u, "readFile.jsp?context="
                    + URLEncoder.encode(context) + "&path="
                    + URLEncoder.encode(path) + "&file="
                    + URLEncoder.encode(file))).getContent();
            ByteArrayOutputStream bo = new ByteArrayOutputStream();
            byte[] buf = new byte[1024];
            int n;
            while ((n = is.read(buf)) != -1)
                bo.write(buf, 0, n);
            content = bo.toString();
            contentChanged = false;
            setChanged();
            notifyObservers();
        } catch (Throwable t) {
            t.printStackTrace();
        }
    }

    /** save the source file in parade */
    public synchronized void save() {
        if (!contentChanged)
            return;
        try {
            URLConnection uc = new URL(u, "writeFile.jsp?context="
                    + URLEncoder.encode(context) + "&path="
                    + URLEncoder.encode(path) + "&file="
                    + URLEncoder.encode(file)).openConnection();

            uc.setDoOutput(true);
            uc.connect();
            uc.getOutputStream().write(
                    ("source=" + URLEncoder.encode(content)).getBytes());
            uc.getContent();

            contentChanged = false;
            setChanged();
            notifyObservers();

        } catch (Throwable t) {
            t.printStackTrace();
        }
    }

    /** the context:path notation used to display in parade */
    public String getParadePath() {
        return "[" + getPrintableContext() + "]:" + path + file;
    }

    public String getPrintableContext() {
        return context.length() == 0 ? "ROOT" : context;
    }
}
