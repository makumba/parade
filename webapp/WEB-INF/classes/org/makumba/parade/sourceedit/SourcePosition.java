package org.makumba.parade.sourceedit;

import java.util.Observable;

/** This class models positions and regions in source files */
public class SourcePosition extends Observable {
    int start, end;

    /** given a text and a position, compute line and column coordinates */
    public static int[] getLineAndColumn(String text, int position) {
        int l = 1;
        int n = 0;
        int lastN = -1;
        while (true) {
            n = text.indexOf("\n", n + 1);
            if (n != -1 && n < text.length() && n < position) {
                l++;
                lastN = n;
                continue;
            }
            break;
        }
        int ret[] = { l, position - lastN };
        return ret;
    }

    /** given a text and a line-column coorinate, compute position */
    public static int getPosition(String text, int line, int column) {
        int n = -1;
        int l = 1;
        while (true) {
            if (n < text.length() && l < line) {
                int n1 = text.indexOf("\n", n + 1);
                if (n1 == -1)
                    break;
                l++;
                n = n1;
                continue;
            }
            break;
        }
        return n + column;
    }

    /** Initialize a position */
    public SourcePosition(int start) {
        this.start = start;
        this.end = -2;
    }

    /** Initialize a region */
    public SourcePosition(int start, int end) {
        this.start = start;
        this.end = end;
    }

    /** Initialize a position or a region in a text */
    public SourcePosition(String text, int sLine, int sColumn, int eLine,
            int eColumn) {
        if (sLine <= 0) {
            start = -2;
            end = -2;
        } else if (eLine <= 0) {
            end = -2;
        }

        if (start != -2)
            start = getPosition(text, sLine, sColumn);
        if (end != -2)
            end = getPosition(text, eLine, eColumn);

        /** if we have a start but no column, we mark the whole line as a region */
        if (start != -2 && sColumn == 0) {
            start++;
            if (end == -2) {
                end = text.indexOf("\n", start);
                if (end == -2)
                    end = text.length();
            }
        }
        /**
         * if we have an end but no column, we extend the region to the end of
         * the line
         */
        else if (end != -2 && eColumn == 0) {
            end++;
            end = text.indexOf("\n", end);
            if (end == -2)
                end = text.length();
        }
    }

    /** Move to a new position */
    public void moveTo(SourcePosition pos) {
        if (pos.isSet() && (this.start != pos.start || this.end != pos.end)) {
            this.start = pos.start;
            this.end = pos.end;

            setChanged();
            notifyObservers(null);
        }
    }

    /** Tell if this position is initialized (start is set) */
    public boolean isSet() {
        return start >= 0;
    }

    /** Tell if this position is a region (both start and end are set) */
    public boolean isRegion() {
        return isSet() && end >= 0;
    }

    /** Get the line of this position in the given text */
    public int getLine(String text) {
        return getLineAndColumn(text)[0];
    }

    /** Get the column of this position in the given text */
    public int getColumn(String text) {
        return getLineAndColumn(text)[1];
    }

    /** Get the line and the column of this position in the given text */
    public int[] getLineAndColumn(String text) {
        return getLineAndColumn(text, start);
    }

    /** get the position negative value means "not set" */
    public int getPosition() {
        return start;
    }

    /** get the region end, negative value means "not set" */
    public int getRegionEnd() {
        return end;
    }
}
