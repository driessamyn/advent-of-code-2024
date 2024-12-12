import java.math.BigInteger

class DiskMap(val map: List<Block>) {
    companion object {
        fun fromString(str: String): DiskMap {
            var id: BigInteger = 0.toBigInteger()
            val list =
                str.mapIndexed { i, c ->
                    val size = c.toString().toInt()
                    List(size) {
                        if (i % 2 == 0) {
                            Block(id, Type.FILE)
                        } else {
                            Block(id, Type.EMPTY)
                        }
                    }.also { if (i % 2 != 0) { id++} }
                }.flatten()
            return DiskMap(list)
        }
    }

    fun defrag() : DiskMap {
        val newMap = map.toMutableList()
        var left = 0
        var right = map.size - 1
        while (left < right) {
            // ffw to empty block
            while(left < right && map[left].type == Type.FILE) {left ++}
            // rwd to file block
            while(left < right && map[right].type == Type.EMPTY) {right --}
            if(left >= right) break;
            newMap[left] = map[right]
            newMap[right] = Block(0.toBigInteger(), Type.MOVED)
            left++
            right--
        }
        return DiskMap(newMap)
    }

    fun defrag2() : DiskMap {
        val newMap = map.toMutableList()
        var right = map.size - 1

        val emptyBlocks = createEmptyBlocksList(map).toMutableList()

        while (right > 0) {
            // rwd to file block
            while(right > 0 && map[right].type == Type.EMPTY) {right --}

            val toMove = mutableListOf(map[right])
            val id = map[right].id
            while(right > 0
                && map[right-1].type == Type.FILE
                && map[right-1].id == id ) {
                right--
                toMove.add(map[right])
            }

            val gap = emptyBlocks.firstOrNull { it.length >= toMove.size }

            if(gap != null && gap.start < right) {
                var left = gap.start
                toMove.forEachIndexed { i, block ->
                    newMap[left] = block
                    newMap[right + i] = Block(0.toBigInteger(), Type.MOVED)
                    left++
                }
                // re-claim the un-used space
                if(toMove.size < gap.length) {
                    gap.start += toMove.size
                    gap.length -= toMove.size
                } else {
                    emptyBlocks.remove(gap)
                }
            }
            right--
        }
        return DiskMap(newMap)
    }

    fun createEmptyBlocksList(from: List<Block>): List<ContinuousEmptyBlocks> {
        val list = mutableListOf<ContinuousEmptyBlocks>()
        var startIndex = -1
        from.forEachIndexed { index, block ->
            if(block.type == Type.EMPTY && startIndex == -1) startIndex = index
            else if (block.type == Type.FILE && startIndex > -1) {
                val b = ContinuousEmptyBlocks(index-startIndex, startIndex)
                list.add(b)
                startIndex = -1
            }
        }
        return list
    }

    fun toCheckSum(): BigInteger {
        return map
            .mapIndexed {index, block ->
                block.getValue().multiply(index.toBigInteger())
            }
            .sumOf { it }
    }

    enum class Type {
        EMPTY, FILE, MOVED
    }
    data class Block(val id: BigInteger, val type: Type) {
        fun getValue() =
            if (type == Type.FILE) id else BigInteger.ZERO

        override fun toString(): String {
            if(Type.MOVED == type ) return "."
            if(Type.EMPTY == type) return "-"
            return "X"
        }
    }

    // hacky mutable
    data class ContinuousEmptyBlocks(var length: Int, var start: Int)

    override fun toString(): String {
        val line1 = StringBuilder()
        val line2 = StringBuilder()
        map.forEach {
            val length = it.id.toString().length
            line1.append(it.id.toString().padEnd(length, ' '))
            line2.append(it.toString().padEnd(length, ' '))
        }

        return line1.append("\n").append(line2).toString()
    }
}

val ext_test_input = "23331331214141314023423"
val ext_testDm = DiskMap.fromString(ext_test_input)

println(ext_testDm)

val test_input = "2333133121414131402"
val testDm = DiskMap.fromString(test_input)

println(testDm)
//println(testDm.createEmptyBlocksList())
val test_defrag = testDm.defrag()
println(test_defrag)
println(test_defrag.toCheckSum())
val test_defrag2 = testDm.defrag2()
println(test_defrag2)
println(test_defrag2.toCheckSum())

val part1_input = java.io.File("day09/data.txt").readText().trim()

val dm = DiskMap.fromString(part1_input)
val defrag_1 = dm.defrag();
val defrag_2 = dm.defrag2();
println(defrag_1.toCheckSum())
println(defrag_2.toCheckSum())
