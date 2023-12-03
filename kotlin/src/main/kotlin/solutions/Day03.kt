package solutions

import kotlin.math.max
import kotlin.math.min

class Day03: Day {
    override fun part1Solution(input: List<String>): String {
        fun isNextToSymbol(startX: Int, startY: Int, endY: Int): Boolean {
            fun Char.isSymbol() = this.isDigit().not() && this != '.'
            val minY = max(startY-1, 0)
            val maxY = min(input.size-1, endY+1)

            if(startX > 0) for (idx in minY..maxY) if(input[startX-1][idx].isSymbol()) return true
            if(startX < input.size-1) for (idx in minY..maxY) if(input[startX+1][idx].isSymbol()) return true
            if(startY > 0 && input[startX][startY-1].isSymbol()) { return true }
            if(endY < input[0].length-1 && input[startX][endY+1].isSymbol()) { return true }
            return false
        }

        var answer = 0
        input.forEachIndexed { lineIdx, line ->
            var startIndex = -1
            line.forEachIndexed { charIdx, char ->
            if(char.isDigit() && startIndex == -1){ startIndex = charIdx }
            else if(!char.isDigit() && startIndex != -1){
                if (isNextToSymbol(lineIdx,startIndex, charIdx - 1)) {
                    answer += line.substring(startIndex..<charIdx).toInt()
                }
                startIndex = -1
            }
        }

            /// If the last char was also a number
            if(startIndex != -1){
                if (isNextToSymbol(lineIdx, startIndex, line.length-1)) {
                    answer += line.substring(startIndex..<line.length).toInt()
                }
            }
        }

        return answer.toString()
    }

    override fun part2Solution(input: List<String>): String {
        fun isNextToSymbol(startX: Int, startY: Int, endY: Int): Pair<Int, Int>? {
            fun Char.isSymbol() = this == '*'
            val minY = max(startY-1, 0)
            val maxY = min(input.size-1, endY+1)

            if(startX > 0) for (idx in minY..maxY) if(input[startX-1][idx].isSymbol()) return startX-1 to idx
            if(startX < input.size-1) for (idx in minY..maxY) if(input[startX+1][idx].isSymbol()) return startX+1 to idx
            if(startY > 0 && input[startX][startY-1].isSymbol()) { return startX to startY-1 }
            if(endY < input[0].length-1 && input[startX][endY+1].isSymbol()) { return startX to endY+1 }
            return null
        }

        val gears = mutableMapOf<Pair<Int, Int>, MutableList<Int>>()
        input.forEachIndexed { lineIdx, line ->
            var startIndex = -1
            line.forEachIndexed { charIdx, char ->
                if(char.isDigit() && startIndex == -1){ startIndex = charIdx }
                else if(!char.isDigit() && startIndex != -1){
                     isNextToSymbol(lineIdx,startIndex, charIdx - 1)?.let {
                        gears.getOrPut(it) { mutableListOf() }.add(line.substring(startIndex..<charIdx).toInt())
                    }
                    startIndex = -1
                }
            }

            /// If the last char was also a number
            if(startIndex != -1){
                isNextToSymbol(lineIdx, startIndex, line.length-1)?.let {
                    gears.getOrPut(it) { mutableListOf() }.add(line.substring(startIndex..<line.length).toInt())
                }
            }
        }

        var answer = 0
        gears.forEach { entry ->
            if(entry.value.size == 2) answer += (entry.value[0] * entry.value[1])
        }
        return answer.toString()
    }
}