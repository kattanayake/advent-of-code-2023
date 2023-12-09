package solutions

class Day09: Day {
    override fun part1Solution(input: List<String>): String {
        return input.filter { it.isNotEmpty() }.sumOf {
            it.split(" ").map { it.toInt() }.let { extrapolate(it) + it.last() }
        }.toString()
    }

    override fun part2Solution(input: List<String>): String {
        return input.filter { it.isNotEmpty() }.sumOf {
            it.split(" ").map { it.toInt() }.let { it.first() - extrapolate(it, false) }
        }.toString()
    }

    private fun extrapolate(nums: List<Int>, forwards: Boolean = true): Int{
        if (nums.all { it == 0 }) return 0
        val next = (1 until nums.size).map {
            nums[it] - nums[it-1]
        }
        val ans = extrapolate(next, forwards)
        return if (forwards) next.last() + ans else next.first() - ans
    }
}