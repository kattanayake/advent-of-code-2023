package solutions

class Day01: Day {
    override fun part1Solution(input: List<String>): String {
        var answer: Int = 0
        input.forEach { line ->
            var first: Char? = null
            var last: Char? = null
            line.forEach {
                if (it.isDigit()){
                    if (first == null) first = it
                    else last = it
                }
            }
            if(last == null) last = first
            answer += ("$first$last").toInt()
        }
        return answer.toString()
    }

    override fun part2Solution(input: List<String>): String {
        var answer = 0
        input.forEach { line ->
            var first: Char? = null
            var last: Char? = null

            fun assign(char: Char) = if (first == null) first = char else last = char

            line.forEachIndexed { index, it ->
                if (it.isDigit()) assign(it)
                else {
                    for(innerIndex in numbers.indices) {
                        val candidate = numbers[innerIndex]
                        if(
                            index < line.length+1-candidate.length &&
                            line.substring(index..<index+candidate.length) == candidate
                        ){
                            assign("${innerIndex+1}"[0])
                            break
                        }
                    }
                }
            }
            if(last == null) last = first
            answer += ("$first$last").toInt()
        }
        return answer.toString()
    }

    companion object {
        private val numbers = listOf(
            "one",
            "two",
            "three",
            "four",
            "five",
            "six",
            "seven",
            "eight",
            "nine"
        )
    }
}