package org.makumba.parade.applets;

import org.makumba.parade.sourceedit.SourcePointer;
import org.makumba.parade.sourceedit.SourcePosition;

/**
 * This is the interface to a generic single source file editor that uses the
 * SourcePointer class to save and load sources can be implemented in all sort
 * of ways, the only constraint about editors is that they have to extend
 * java.awt.Component
 */
public interface Editor {
    /** load the source file into the editor */
    public void load(SourcePointer p);

    /** reload the source file into the editor */
    public void reload();

    /** save the source file */
    public void save();

    /** read the current text, e.g. for edit mode's search */
    public String getText();

    /** set the text to something else */
    public void setText(String s);

    /** move to a position or mark a region into the source file view */
    public void pointTo(SourcePosition pos);

    /** move to position into the source file view */
    public void pointTo(int n);

    /** read position as SourcePosition */
    public SourcePosition getSourcePosition();

    /** read position as int, e.g. for edit modes */
    public int getIntPosition();

    /** set the edit mode */
    public void setEditMode(EditMode em);

    /** get the edit mode */
    public EditMode getEditMode();
}
