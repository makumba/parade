package org.makumba.parade.applets;

import java.awt.BorderLayout;
import java.awt.Button;
import java.awt.CardLayout;
import java.awt.Choice;
import java.awt.Component;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.Label;
import java.awt.Panel;
import java.awt.TextField;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.util.Dictionary;
import java.util.Hashtable;
import java.util.Observable;
import java.util.Observer;
import java.util.Vector;

import org.makumba.parade.sourceedit.SourcePointer;
import org.makumba.parade.sourceedit.SourcePosition;
import org.makumba.parade.sourceedit.StatusDisplay;

/**
 * a multiple editor, allowing choiche of file to edit, and basic operations:
 * save, revert, goto line in the current file
 */
public class MultipleEditor extends Panel {
    Dictionary buffers = new Hashtable();

    Dictionary positions = new Hashtable();

    Vector choiceOrder = new Vector();

    Choice bufferChoice = new Choice();

    StatusDisplay status;

    public void setStatusDisplay(StatusDisplay sd) {
        status = sd;
    }

    Observer positionObserver = new Observer() {
        public void update(Observable subject, Object event) {
            setLine((SourcePosition) subject);
        }
    };

    Observer sourceObserver = new Observer() {
        public void update(Observable subject, Object event) {
            if (bufferChoice.getItemCount() > 0) {
                // we update the current list element (number 0) because
                // probably
                // there was a save or a reload
                bufferChoice.remove(0);
                bufferChoice.insert(getChoiceLine((SourcePointer) subject), 0);
            }
            if (((SourcePointer) subject).getChanged()) {
                save.enable();
            } else {
                // this only has effect the first time. first event mens "i'm
                // loaded now"
                revert.enable();
                save.disable();
            }
        }
    };

    /** load a new file */
    public void loadFile(SourcePointer sp, SourcePosition pos) {
        String s = sp.getHashString();
        String choice = getChoiceLine(sp);

        if (buffers.get(s) == null) {
            // we want to know when the file has changed
            sp.addObserver(sourceObserver);
            positions.put(s, pos);
            pos.addObserver(positionObserver);

            Editor e = makeEditor();
            ((Component) e).disable();
            e.load(sp);
            buffers.put(s, e);

            editors.add(s, (Component) e);
            choiceOrder.insertElementAt(s, 0);
            bufferChoice.insert(choice, 0);
            e.pointTo(pos);

            // for some reason, bufferChoice.select(choice) does not produce
            // ItemEvent here
            // so we call select() directly
            select();
            sourceObserver.update(sp, null);
            ((Component) e).enable();
        } else
        // if the file is not new in this multiple editor, we change the
        // bufferChoice position
        {
            bufferChoice.select(choice);
            select();
        }

        ((Editor) buffers.get(s)).pointTo(pos);

        // we show status in a separate thread, so the default statuses shown by
        // the browser
        // will be overwritten
        final SourcePointer sp1 = sp;
        new Thread() {
            public void run() {
                try {
                    Thread.sleep(500);
                } catch (InterruptedException e) {
                }
                status.showStatus("Loaded " + getChoiceLine(sp1));
            }
        }.start();
    }

    /**
     * change the bufferChoice order, put the item selected in bufferChoice
     * first
     */
    public void select() {
        int n = bufferChoice.getSelectedIndex();
        String s = (String) choiceOrder.elementAt(n);
        String choice = bufferChoice.getItem(n);
        if (n != 0) {
            choiceOrder.removeElementAt(n);
            bufferChoice.remove(n);
            choiceOrder.insertElementAt(s, 0);
            bufferChoice.insert(choice, 0);
        }
        card.show(editors, s);
        ((Component) buffers.get(s)).requestFocus();
        setLine((SourcePosition) positions.get(s));
    }

    void setLine(SourcePosition sp) {
        int[] lc = sp.getLineAndColumn(getCurrentEditor().getText());
        lineEditor.setText("" + lc[0]);
        status.showStatus(lc[0] + ":" + lc[1]);
    }

    String getChoiceLine(SourcePointer sp) {
        return (sp.getChanged() ? "** " : "   ") + sp.getParadePath();
    }

    CardLayout card = new CardLayout();

    Panel editors = new Panel();

    Panel menu = new Panel();

    Panel buttons = new Panel();

    TextField lineEditor = new TextField(8);

    Button save = new Button("Save");

    Button revert = new Button("Revert");

    /** get the current editor as a component */
    Component getCurrentComponent() {
        return ((Component) buffers.get(choiceOrder.elementAt(0)));
    }

    /** get the current editor */
    Editor getCurrentEditor() {
        return ((Editor) buffers.get(choiceOrder.elementAt(0)));
    }

    public MultipleEditor() {
        bufferChoice.addItemListener(new ItemListener() {
            /** implementation of item listener */
            public void itemStateChanged(ItemEvent e) {
                if (e.getStateChange() == ItemEvent.SELECTED)
                    select();
            }
        });

        revert.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                status.showStatus("Reverting ...");
                getCurrentComponent().disable();
                getCurrentEditor().reload();
                getCurrentComponent().enable();
                getCurrentComponent().requestFocus();
                status.showStatus("Done.");
            }
        });

        save.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                status.showStatus("Saving ...");
                getCurrentComponent().disable();
                getCurrentEditor().save();
                getCurrentComponent().enable();
                getCurrentComponent().requestFocus();
                status.showStatus("Done.");
            }
        });

        lineEditor.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                String s = lineEditor.getText();
                int ln = 0;
                try {
                    ln = Integer.parseInt(s.trim());
                } catch (NumberFormatException nfe) {
                }
                if (ln > 0) {
                    getCurrentEditor().pointTo(
                            new SourcePosition(getCurrentEditor().getText(),
                                    ln, 0, 0, 0));
                    getCurrentComponent().requestFocus();
                } else {
                    int index = getCurrentEditor().getText().indexOf(s,
                            getCurrentEditor().getIntPosition());
                    if (index == -1)
                        index = getCurrentEditor().getText().indexOf(s);
                    if (index == -1)
                        index = getCurrentEditor().getText().toLowerCase()
                                .indexOf(s.toLowerCase(),
                                        getCurrentEditor().getIntPosition());
                    if (index == -1)
                        index = getCurrentEditor().getText().toLowerCase()
                                .indexOf(s.toLowerCase());

                    if (index != -1) {
                        getCurrentEditor().pointTo(
                                new SourcePosition(index, index + s.length()));
                        getCurrentComponent().requestFocus();
                    } else {
                        status.showStatus("Not found: " + s);
                        setLine(((SourcePosition) positions.get(choiceOrder
                                .elementAt(0))));
                    }
                }
            }
        });

        bufferChoice.setFont(new Font("Courier", Font.PLAIN, 12));

        save.disable();
        revert.disable();

        setLayout(new BorderLayout());
        editors.setLayout(card);

        buttons.setLayout(new FlowLayout());
        buttons.add(save);
        buttons.add(revert);
        buttons.add(new Label("Line/Find:"));
        buttons.add(lineEditor);

        menu.setLayout(new BorderLayout());
        menu.add("Center", bufferChoice);
        menu.add("East", buttons);

        add("Center", editors);
        add("North", menu);
    }

    /** factory method to make an editor, can return sth else later on */
    public Editor makeEditor() {
        return new TextboxEditor();
    }
}
