package solutions

import kotlin.math.abs

class Day11: Day {
    override fun part1Solution(input: List<String>): String {
        return calculate(input, 2).toString()
    }

    override fun part2Solution(input: List<String>): String {
        return calculate(input, 1000000).toString()
    }

    private fun calculate(input: List<String>, expansionConstant: Int): Long {
        val galaxies = mutableListOf<Pair<Int, Int>>()
        val rowHasGalaxy = BooleanArray(input.size)
        val colHasGalaxy = BooleanArray(input[0].length)
        input.forEachIndexed { rowIdx, row ->
            row.forEachIndexed { index, c ->
                if (c=='#'){
                    galaxies.add(rowIdx to index)
                    rowHasGalaxy[rowIdx] = true
                    colHasGalaxy[index] = true
                }
            }
        }

        val expandedGalaxies = galaxies.map { it }.toMutableList()
        for(i in rowHasGalaxy.indices){
            if (!rowHasGalaxy[i]){
                galaxies.forEachIndexed { index, pair ->
                    if (pair.first > i){
                        val data = expandedGalaxies[index]
                        expandedGalaxies[index] = (data.first + (expansionConstant - 1)) to data.second

                    }
                }
            }
        }
        for(j in colHasGalaxy.indices){
            if (!colHasGalaxy[j]){
                galaxies.forEachIndexed { index, pair ->
                    if (pair.second > j){
                        val data = expandedGalaxies[index]
                        expandedGalaxies[index] = data.first to (data.second + (expansionConstant - 1))
                    }
                }
            }
        }

        var cumulativeDistance = 0L
        for (i in expandedGalaxies.indices){
            val first = expandedGalaxies[i]
            for (j in (i+1) until expandedGalaxies.size){
                val second = expandedGalaxies[j]
                cumulativeDistance += (abs(first.first - second.first) + abs(first.second - second.second))
            }
        }
        return cumulativeDistance
    }
}