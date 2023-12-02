package solutions

import kotlin.math.max

class Day02: Day {
    override fun part1Solution(input: List<String>): String {
        val redMax = 12
        val greenMax = 13
        val blueMax = 14

        var answer = 0
        input.forEach { line ->
            var gameIsBad = false
            line.split(":")[1].split(";").forEach { round ->
                var redCount = 0
                var greenCount = 0
                var blueCount = 0
                round.split(",").forEach { pair ->
                    val parts = pair.trim().split(" ")
                    if(parts[1] == "red") redCount += parts[0].toInt()
                    else if (parts[1] == "green") greenCount += parts[0].toInt()
                    else if (parts[1] == "blue") blueCount += parts[0].toInt()
                }
                if(redCount > redMax || blueCount > blueMax || greenCount > greenMax) gameIsBad = true
            }
            if (!gameIsBad) answer += line.split(":")[0].split(" ")[1].toInt()
        }

        return answer.toString()
    }

    override fun part2Solution(input: List<String>): String {
        var answer = 0
        input.forEach { line ->
            var redCount = 0
            var greenCount = 0
            var blueCount = 0
            line.split(":")[1].split(";").forEach { round ->
                round.split(",").forEach { pair ->
                    val parts = pair.trim().split(" ")
                    if(parts[1] == "red") redCount = max(redCount, parts[0].toInt())
                    else if (parts[1] == "green") greenCount = max(greenCount, parts[0].toInt())
                    else if (parts[1] == "blue") blueCount = max(blueCount, parts[0].toInt())
                }
            }
            answer += (redCount * greenCount * blueCount)
        }

        return answer.toString()
    }
}