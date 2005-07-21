package org.makumba.parade.applets;

import java.awt.event.KeyAdapter;

/**
 * an edit mode, a way to interpret key events during editing edit modes are
 * interchangeable at any time
 */
public abstract class EditMode extends KeyAdapter {
    // the editor handled by the mode
    Editor editor;

    public EditMode(Editor e) {
        editor = e;
    }

    /** name to be displayed when the mode is chosen */
    public abstract String getName();
}
