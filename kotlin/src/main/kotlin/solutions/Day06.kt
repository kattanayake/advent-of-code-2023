package solutions

class Day06: Day {
    override fun part1Solution(input: List<String>): String {
        val times = input[0].split(":")[1].split(" ").filter { it.isNotEmpty() }.map { it.toLong() }
        val distances = input[1].split(":")[1].split(" ").filter { it.isNotEmpty() }.map { it.toLong() }
        val answers = mutableListOf<Int>()

        for (index in times.indices) {
            var permutations = 0
            val target = distances[index]
            val time = times[index]
            for(dur in 0..time) {
                if ((dur * (time - dur)) > target ) permutations++
                else if (permutations > 0) break
            }
            answers.add(permutations)
        }
        return answers.reduce { acc, i -> acc * i }.toString()
    }

    override fun part2Solution(input: List<String>): String {
        val time = input[0].split(":")[1].split(" ").joinToString("").toLong()
        val target = input[1].split(":")[1].split(" ").joinToString("").toLong()

        var permutations = 0
        for(dur in 0..time) {
            if ((dur * (time - dur)) > target ) permutations++
            else if (permutations > 0) break
        }
        return permutations.toString()
    }
}