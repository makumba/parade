package org.makumba.parade;

import java.util.Comparator;
import java.util.Map;

import javax.servlet.ServletRequest;

public class MapComparator implements Comparator {
    String fieldName;

    public MapComparator(ServletRequest request, String defaultOrder) {
        fieldName = defaultOrder;
        if (request != null && request.getParameterValues("order") != null)
            fieldName = request.getParameterValues("order")[0];
    }

    public int compare(Object o1, Object o2) {
        Object f1 = ((Map) o1).get("isFolder");
        Object f2 = ((Map) o2).get("isFolder");
        if (f1 != null && f2 == null)
            return -1;
        if (f2 != null && f1 == null)
            return 1;

        Comparable c1 = (Comparable) ((Map) o1).get(fieldName);
        Comparable c2 = (Comparable) ((Map) o2).get(fieldName);
        if (c2 == null && c1 == null)
            return 0;
        if (c2 == null)
            return 1;
        if (c1 == null)
            return -1;

        return c1.compareTo(c2);
    }
}
