package solutions

import helpers.lowestCommonMultiple
import kotlin.math.max
import kotlin.math.min

class Day08: Day {
    override fun part1Solution(input: List<String>): String {
        val instructions = input[0]
        val nodes = mutableMapOf<String, List<String>>()
        for(lineIndex in 2..<input.size){
            val lineParts = input[lineIndex].split("=")
            nodes[lineParts[0].trim()] = lineParts[1].split(",").map{
                it.trim('(',')',' ')
            }
        }
        var curNode = "AAA"
        var curIndex = 0
        var answer = 0

        while(curNode != "ZZZ"){
            val direction = instructions[curIndex]
            val newIndex = if (direction == 'L') 0 else 1
            curNode = nodes[curNode]!![newIndex]
            answer += 1
            curIndex = (curIndex + 1) % instructions.length
        }

        return answer.toString()
    }

    override fun part2Solution(input: List<String>): String {
        val instructions = input[0]
        val nodes = mutableMapOf<String, List<String>>()
        for(lineIndex in 2..<input.size){
            val lineParts = input[lineIndex].split("=")
            nodes[lineParts[0].trim()] = lineParts[1].split(",").map{
                it.trim('(',')',' ')
            }
        }
        val curNodes = nodes.keys.filter { it.last() == 'A' }.toMutableList()
        var curIndex = 0
        var iterations = 0
        val LCMs = IntArray(curNodes.size) { -1 }
        while(!LCMs.all { it != -1 }){
            val direction = instructions[curIndex]
            val newIndex = if (direction == 'L') 0 else 1
            curNodes.forEachIndexed { nodeIndex, curNode ->
                curNodes[nodeIndex] = nodes[curNode]!![newIndex]
                if (curNodes[nodeIndex].last() == 'Z' && LCMs[nodeIndex] == -1){
                    LCMs[nodeIndex] = iterations + 1
                }
            }
            iterations += 1
            curIndex = (curIndex + 1) % instructions.length
        }

        var accumulator = 1L
        for (lcm in LCMs){
            accumulator = lowestCommonMultiple(accumulator, lcm.toLong())
        }

        return accumulator.toString()
    }


}