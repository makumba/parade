package org.makumba.parade.applets;

import java.awt.BorderLayout;

import org.makumba.parade.sourceedit.SourcePointer;
import org.makumba.parade.sourceedit.SourcePosition;
import org.makumba.parade.sourceedit.StatusDisplay;

public class EditApplet extends java.applet.Applet implements StatusDisplay {
    int getPosition(String param) {
        if (param == null)
            return 0;
        return Integer.parseInt(param.trim());
    }

    MultipleEditor me = new MultipleEditor();

    public void init() {
        setLayout(new BorderLayout());
        me.setStatusDisplay(this);
        add("Center", me);
        if (getParameter("context") != null)
            loadFile(getParameter("context"), getParameter("dir"),
                    getParameter("file"), getParameter("line"),
                    getParameter("column"), getParameter("endLine"),
                    getParameter("endColumn"));
    }

    public void loadFile(String context, String path, String file) {
        loadFile(context, path, file, null, null, null, null);
    }

    public void loadFile(String context, String path, String file, String line,
            String column, String endLine, String endColumn) {
        SourcePointer sp = new SourcePointer(getCodeBase(), context, path, file);
        me.loadFile(sp, new SourcePosition(sp.getText(), getPosition(line),
                getPosition(column), getPosition(endLine),
                getPosition(endColumn)));
    }

}
