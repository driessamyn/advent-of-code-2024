def here = "."
def larger_example = new File("${here}/test-data.txt").text
def real = new File("$here/data.txt").text

final NEIGHBOURS = [[1,0], [-1,0], [0,-1], [0,1]]

def toGrid = { String str -> 
    str.split().collect { it.collect() }
}

def getMap = { grid ->
    grid.withIndex().collectMany { row, r ->
        row.withIndex().collect { cell, c ->
            [[r, c], cell]
        }
    }.collectEntries()
}

def dfs = { plotMap, pos, seen ->
    def name = plotMap[pos]
    def region = []
    def fence = []
    def toVisit = [pos]
    def visited = [pos] as Set
    seen.add(pos)
    
    while (!toVisit.empty) {
        def current = toVisit.pop()
        region << current
        def (r, c) = current
        
        NEIGHBOURS.each { n ->
            def newPos = [r + n[0], c + n[1]]
            if (!visited.contains(newPos)) {
                if (plotMap.containsKey(newPos) && plotMap[newPos] == name) {
                    visited.add(newPos)
                    seen.add(newPos)
                    toVisit << newPos
                } else {
                    fence << [newPos, n]
                }
            }
        }
    }
    
    [region, fence]
}

def calculateSides = { fences ->
    def visited = [] as Set
    
    fences.inject(0) { count, fence ->
        if (visited.contains(fence)) return count
        
        def pos = fence[0]
        def dir = fence[1]
        def queue = [pos]
        visited.add(fence)
        
        while (!queue.empty) {
            def (r, c) = queue.remove(0)
            NEIGHBOURS.each { n ->
                def newPos = [r + n[0], c + n[1]]
                def newFence = [newPos, dir]
                if (fences.contains(newFence) && !visited.contains(newFence)) {
                    queue << newPos
                    visited.add(newFence)
                }
            }
        }
        
        count + 1
    }
}

def calculateFencePrice = { grid ->
    def plotMap = getMap(grid)
    def seen = [] as Set
    
    plotMap.inject(0) { price, entry ->
        def pos = entry.key
        if (seen.contains(pos)) return price
        
        def (regions, fences) = dfs(plotMap, pos, seen)
        price + regions.size() * fences.size()
    }
}

def calculateFenceBulkPrice = { grid ->
    def plotMap = getMap(grid)
    def seen = [] as Set
    
    plotMap.inject(0) { price, entry ->
        def pos = entry.key
        if (seen.contains(pos)) return price
        
        def (regions, fences) = dfs(plotMap, pos, seen)
        def sides = calculateSides(fences)
        price + regions.size() * sides
    }
}

// Main execution
def grid = toGrid(larger_example)
println "Part 1: ${calculateFencePrice(grid)}"

grid = toGrid(real)
println "Part 1: ${calculateFencePrice(grid)}"

grid = toGrid(real)
println "Part 2: ${calculateFenceBulkPrice(grid)}"