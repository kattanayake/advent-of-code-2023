package solutions

class Day12: Day {

    override fun part1Solution(input: List<String>): String {
        var answer = 0L
        input.forEach { line ->
            val lineParts = line.split(" ")
            val springs = lineParts[0]
            val groupings = lineParts[1].split(",").map { it.toInt() }
            answer += solve(springs, groupings)
        }
        return answer.toString()
    }

    override fun part2Solution(input: List<String>): String {
        var answer = 0L
        input.forEach { line ->
            val lineParts = line.split(" ")
            val springs = lineParts[0]
            val groupings = lineParts[1].split(",").map { it.toInt() }

            var springAlt = springs
            val groupingsAlt = groupings.toMutableList()

            repeat(4){
                springAlt = "$springAlt?$springs"
                groupingsAlt.addAll(groupings)
            }

            answer += solve(springAlt, groupingsAlt)
        }
        return answer.toString()
    }
    private fun solve(input: String, groups: List<Int>): Long {
        val cache = mutableMapOf<Pair<String, List<Int>>, Long>()
        fun goDeeper(line: String, values: List<Int>, index: Int): Long {
            if (index >= line.length) {
                if (values.isEmpty()) {
                    return 1
                }
                return 0
            }
            var answer = 0L

            // Short circuit
            val substring = line.substring(index..<line.length)
            if (substring to values in cache){
                return cache[substring to values]!!
            }

            if (values.isNotEmpty()) {
                if ((index+(values[0] - 1) < line.length) &&
                    line.substring(index..<(index+values[0])).all{ it == '?' || it == '#' } &&
                    (index+values[0] == line.length || line[index+values[0]] != '#')
                ){
                    answer += goDeeper(line, values.subList(1, values.size), index + values[0] + 1)
                }
                if (line[index] == '#') {
                    cache[substring to values] = answer
                    return answer
                }
                answer += goDeeper(line, values, index + 1)
            } else if (line[index] == '#') {
                cache[substring to values] = 0
                return 0
            } else {
                 answer += goDeeper(line, values, index + 1)
            }
            cache[substring to values] = answer
            return answer
        }
        return goDeeper(input, groups, 0)
    }

}