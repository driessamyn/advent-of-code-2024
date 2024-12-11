public static void main(String[] args) {
    int found = 0;
    for(String line : data.split("\n")) {
        var values =
                Arrays.stream(line.split(" "))
                        .map(Integer::parseInt).toList();
        if(isSafe(values)) found++;
    }
    System.out.println(found);
}

private static boolean isSafe(List<Integer> values) {
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
                || value == previous) return false;
        if(Math.abs(value - previous) > 3 ) return false;
        previous = value;
    }
    System.out.println(values);
    return true;
}