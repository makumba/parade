package org.makumba.parade.applets;

import java.awt.Color;
import java.awt.Cursor;
import java.awt.Dimension;
import java.awt.Frame;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.image.ImageObserver;

import org.makumba.parade.sourceedit.SourcePointer;
import org.makumba.parade.sourceedit.SourcePosition;

public class FileOpenApplet extends java.applet.Applet {
    static Image icon;

    static Frame frame;

    static MultipleEditor editor;

    static {
        frame = new TheFrame();
        editor = new MultipleEditor();
        frame.add(editor, "Center");
        frame.pack();
    }

    int getPosition(String param) {
        String s = getParameter(param);
        if (s == null)
            return 0;
        return Integer.parseInt(s.trim());
    }

    public void init() {
        System.out.println(getClass().getClassLoader());
        if (icon == null)
            icon = getImage(getCodeBase(), "images/edit.gif");

        final SourcePointer sp = new SourcePointer(getCodeBase(),
                getParameter("context"), getParameter("dir"),
                getParameter("file"));
        final SourcePosition pos = new SourcePosition(sp.getText(),
                getPosition("line"), getPosition("column"),
                getPosition("endLine"), getPosition("endColumn"));

        setCursor(Cursor.getPredefinedCursor(Cursor.HAND_CURSOR));
        addMouseListener(new MouseAdapter() {
            public void mouseClicked(MouseEvent me) {
                editor.loadFile(sp, pos);
                frame.setVisible(true);
                frame.toFront();
            }
        });
    }

    public void paint(Graphics g) {
        g.drawImage(icon, 0, 0, Color.WHITE, imObserver);
    }

    ImageObserver imObserver = new ImageObserver() {
        public boolean imageUpdate(Image im, int status, int x, int y, int w,
                int h) {
            // when the image load finishes, we repaint
            if ((status & ImageObserver.ALLBITS) == 1) {
                repaint();
            }
            return ((status & (ImageObserver.ALLBITS | ImageObserver.ABORT | ImageObserver.ERROR)) == 0);
        }
    };
}

class TheFrame extends Frame {
    public TheFrame() {
        super("Parade file editor");
        setLocation(20, 50);
        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent we) {
                setVisible(false);
            }
        });
    }

    final static Dimension dim = new Dimension(600, 400);

    public Dimension getPreferredSize() {
        return dim;
    }
}
