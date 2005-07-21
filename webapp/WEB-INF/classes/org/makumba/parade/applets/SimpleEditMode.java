package org.makumba.parade.applets;

import java.awt.event.KeyEvent;

/** a very simple edit mode, knows how to save at ctrl-s */
public class SimpleEditMode extends EditMode {
    public SimpleEditMode(Editor ed) {
        super(ed);
    }

    public String getName() {
        return "simple";
    }

    public void keyReleased(KeyEvent e) {
        // sometimes ctrl-s doesn't work, print the event to try to debug
        // System.out.println(e);
        if (e.isControlDown() && !e.isAltDown() && !e.isMetaDown()
                && (e.getKeyCode() == (int) 's' || e.getKeyCode() == (int) 'S')) {
            editor.save();

            // we consume the event, so it won't matter in the textarea
            e.consume();
        }
    }
}
