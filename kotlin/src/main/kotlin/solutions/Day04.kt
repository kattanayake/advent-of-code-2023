package solutions

import java.lang.Math.pow

class Day04: Day {
    override fun part1Solution(input: List<String>): String {
        var answer = 0
        input.forEach { game ->
            val (winning, regular) = game.split(":")[1].split("|").map {nums ->
                nums.split(" ").filter { it.isNotEmpty() }.map { it.toInt() }
            }
            winning.intersect(regular.toSet()).let {
                if (it.isNotEmpty()) answer += pow(2.0, (it.size-1).toDouble()).toInt()
            }
        }
        return answer.toString()
    }

    override fun part2Solution(input: List<String>): String {
        val multipliers = IntArray(input.size){ 1 }
        input.forEachIndexed { index, game ->
            val (winning, regular) = game.split(":")[1].split("|").map { nums ->
                nums.split(" ").filter { it.isNotEmpty() }.map { it.toInt() }
            }
            for(gameNum in 1..winning.intersect(regular.toSet()).size){
                multipliers[index+gameNum] += multipliers[index]
            }
        }
        return multipliers.sum().toString()
    }
}