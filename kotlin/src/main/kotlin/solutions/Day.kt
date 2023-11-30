package solutions

import kotlin.io.path.Path
import kotlin.io.path.readLines

interface Day {

    /**
     * Solution to part 1 of a problem.
     */
    fun part1Solution(input: List<String>): String

    /**
     * Solution to part 2 of a problem
     */
    fun part2Solution(input: List<String>): String

    /**
     *  Validates that [part1Solution] correctly solves the problem example
     */
    fun validate() = check(loadFile(EXAMPLE_ANSWER).first() == part1Solution(loadFile(EXAMPLE_INPUT)))

    /**
     * Solves part 1 of the challenge
     */
    fun part1() = println(part1Solution(loadFile(PART_ONE_INPUT)))

    /**
     * Solves part 1 of the challenge
     */
    fun part2() = println(part1Solution(loadFile(PART_TWO_INPUT)))

    private fun loadFile(file: String): List<String>{
        val relativePath = this.javaClass.simpleName.lowercase()
        return Path(PATH_PREFIX + relativePath + file).readLines()
    }

    companion object {
        private const val PATH_PREFIX = "src/main/resources/"
        private const val EXAMPLE_INPUT = "/ExampleIn.txt"
        private const val EXAMPLE_ANSWER = "/ExampleOut.txt"
        private const val PART_ONE_INPUT = "/Part1In.txt"
        private const val PART_TWO_INPUT = "/Part2In.txt"
    }

}