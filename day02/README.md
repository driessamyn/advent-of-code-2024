# Day 2

Choose JAVA for day 2.
So much code for so little ... :(

## Part 1

```java
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
```

## Part 2

Not really happy with the brute-force way of doing this :(

```java
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
```