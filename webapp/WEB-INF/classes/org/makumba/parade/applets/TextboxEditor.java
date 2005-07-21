package org.makumba.parade.applets;

import java.awt.Font;
import java.awt.TextArea;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.TextEvent;
import java.awt.event.TextListener;

import org.makumba.parade.sourceedit.SourcePointer;
import org.makumba.parade.sourceedit.SourcePosition;

/** a simple implementation of an editor, based on a textarea */
public class TextboxEditor extends TextArea implements Editor {
    SourcePointer sp;

    SourcePosition pos;

    EditMode mode;

    TextboxEditor() {
        // FIXME: once more edit modes are defined, the user should be able to
        // choose the edit mode
        // maybe from a dropdown in MultipleEdit...
        setEditMode(new SimpleEditMode(this));
        setFont(new Font("Courier", Font.PLAIN, 12));
        addMouseListener(new MouseAdapter() {
            // the user moved the caret by the mouse
            public void mousePressed(MouseEvent e) {
                pos.moveTo(new SourcePosition(getCaretPosition()));
            }

            public void mouseReleased(MouseEvent e) {
                pos.moveTo(new SourcePosition(getCaretPosition()));
            }
        });
        addKeyListener(new KeyAdapter() {
            // the user messed with the keyboard, we need to compute the
            // line/column
            public void keyPressed(KeyEvent e) {
                pos.moveTo(new SourcePosition(getCaretPosition()));
            }

            public void keyReleased(KeyEvent e) {
                pos.moveTo(new SourcePosition(getCaretPosition()));
            }
        });
        addTextListener(new TextListener() {
            public void textValueChanged(TextEvent e) {
                // the content changed, we ask the SourcePointer to change
                sp.change(getText());
            }
        });

    }

    boolean firstPaint = true;

    /** we detect the first paint, and compute caret position, select region, etc */
    public void paint(java.awt.Graphics g) {
        super.paint(g);
        if (!firstPaint || !isShowing())
            return;
        firstPaint = false;
        setCaretPosition(pos.getPosition());
        if (pos.isRegion())
            select(pos.getPosition(), pos.getRegionEnd());
    }

    /** get the edit mode */
    public EditMode getEditMode() {
        return mode;
    }

    /** set the edit mode */
    public void setEditMode(EditMode em) {
        if (mode != null)
            removeKeyListener(mode);
        mode = em;
        addKeyListener(em);
    }

    /** load the source file into the editor */
    public void load(SourcePointer p) {
        if (sp == null) {
            setText(p.getContent());
            this.sp = p;
        }
    }

    /** reload the source file into the editor */
    public void reload() {
        sp.load();
        setText(sp.getContent());

        pos.moveTo(new SourcePosition(getText(), pos.getLine(getText()), 1, 0,
                0));
        setCaretPosition(pos.getPosition());
    }

    /** save */
    public void save() {
        sp.save();
    }

    /** mark a position into the source file view */
    public void pointTo(SourcePosition ps) {
        // if we are at the begining
        if (pos == null) {
            if (!ps.isSet()) {
                ps.moveTo(new SourcePosition(getText(), 1, 1, 0, 0));
            }
            pos = ps;
            // FIXME: if we actually have a region or a line indicated,
            // we should be able to display it when we get displayed...
        } else if (ps.isSet()) {
            pos.moveTo(ps);

            // move the caret at the begining of the indicated line
            // FIXME: here we should actually select a region if ps.isRegion()
            // but the applet tag is not yet sending even line numbers
            if (isShowing()) {
                setCaretPosition(pos.getPosition());
                if (pos.isRegion())
                    select(pos.getPosition(), pos.getRegionEnd());
            }
        }
    }

    /** move to a position */
    public void pointTo(int n) {
        setCaretPosition(n);
        pos.moveTo(new SourcePosition(n));
    }

    /** read position as SourcePosition */
    public SourcePosition getSourcePosition() {
        return pos;
    }

    /** read position as int */
    public int getIntPosition() {
        return getCaretPosition();
    }
}
