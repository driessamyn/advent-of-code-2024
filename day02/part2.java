private static boolean isSafeIsh(List<Integer> values) {
    var ar = new ArrayList<>(values);
    int previous = ar.removeFirst();
    Boolean isIncrementing = null;
    for(Integer value : ar) {
        if(null == isIncrementing && value > previous) {
            isIncrementing = true;
        } else  if (null == isIncrementing) {
            isIncrementing = false;
        }

        if(isIncrementing && value < previous
                || !isIncrementing && value > previous
                || value == previous
                || Math.abs(value - previous) > 3) {

            // Brute force check if any can be dropped out.
            // There must a more efficient way :(
            for(int i = 0; i < values.size(); i++) {
                var reduced = new ArrayList<>(values);
                reduced.remove(i);
                if(isSafe(reduced)) return true;
            }
            return false;
        }
        previous = value;
    }
    System.out.println(values);
    return true;
}