package solutions

class Day14: Day {
    private lateinit var grid: MutableList<CharArray>
    private val trickles
        get() = listOf(
            Trickle(
                outerRange = 0..<grid.size,
                innerRange = 0..<grid.first().size,
                trickle = { x, y -> Triple(x - 1, y, x == 0) }
            ),
            Trickle(
                outerRange = 0..<grid.first().size,
                innerRange = 0..<grid.size,
                trickle = { x, y -> Triple(x, y - 1, y == 0) }
            ),
            Trickle(
                outerRange = (grid.size - 1) downTo 0,
                innerRange = 0..<grid.first().size,
                trickle = { x, y -> Triple(x + 1, y, x == grid.size - 1) }
            ),
            Trickle(
                outerRange = (grid.first().size - 1) downTo 0,
                innerRange = 0..<grid.size,
                trickle = { x, y -> Triple(x, y + 1, y == grid[0].size - 1) }
            ),
        )


    private fun trickle(x: Int, y: Int, direction: (Int, Int) -> Triple<Int, Int, Boolean>){
        val (nextX, nextY, edgeReached) = direction(x, y)
        if (edgeReached) return
        if (grid[x][y] == 'O' && grid[nextX][nextY] == '.') {
            grid[x][y] = '.'
            grid[nextX][nextY] = 'O'
            trickle(nextX, nextY ,direction)
        }
    }
    override fun part1Solution(input: List<String>): String {
        grid = input.mapNotNull { if(it.isNotEmpty()) it.toCharArray() else null }.toMutableList()
        for (i in trickles.first().outerRange){
            for (j in trickles.first().innerRange){
                trickle(i, j, trickles.first().trickle)
            }
        }
        var answer = 0
        grid.forEachIndexed { index, chars ->
            chars.forEach {
                if (it == 'O') answer += (grid.size - index)
            }
        }
        return answer.toString()
    }

    override fun part2Solution(input: List<String>): String {
        val cycles = 1_000_000_000L
        grid = input.mapNotNull { if(it.isNotEmpty()) it.toCharArray() else null }.toMutableList()
        val cache = mutableMapOf<String, Long>()
        for (iteration in 0 until cycles) {
            trickles.forEachIndexed { index, direction ->
                for (i in direction.outerRange) {
                    for (j in direction.innerRange) {
                        trickle(
                            if (index % 2 == 0) i else j,
                            if (index % 2 == 0) j else i,
                            direction.trickle
                        )
                    }
                }
            }
            val gridState = grid.joinToString(separator = "") { it.joinToString(separator = "") }
            val prev = cache[gridState]
            if(prev != null){
                if ((cycles - prev ) % ((iteration + 1) - prev) == 0L){
                    break
                }
            }
            cache[gridState] = (iteration + 1)
        }
        var answer = 0
        grid.forEachIndexed { index, chars ->
            chars.forEach {
                if (it == 'O') answer += (grid.size - index)
            }
        }
        return answer.toString()
    }

    data class Trickle(
        val outerRange: IntProgression,
        val innerRange: IntProgression,
        /// Returns (nextX, nextY, edgeReached)
        val trickle: (Int, Int) -> Triple<Int, Int, Boolean>
    )
}