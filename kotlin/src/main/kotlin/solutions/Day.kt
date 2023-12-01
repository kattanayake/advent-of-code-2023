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
    fun validatePart1() {
        print("Validating part 1 ... ")
        check(loadFile(EXAMPLE_PART_1_ANSWER).first() == part1Solution(loadFile(EXAMPLE_PART_1_INPUT)))
        println("Validation complete")
    }

    /**
     *  Validates that [part2Solution] correctly solves the problem example
     */
    fun validatePart2() {
        print("Validating part 2 ... ")
        check(loadFile(EXAMPLE_PART_2_ANSWER).first() == part2Solution(loadFile(EXAMPLE_PART_2_INPUT)))
        println("Validation complete")
    }


    /**
     * Solves part 1 of the challenge
     */
    fun part1() {
        print("Solving part 1:")
        println(part1Solution(loadFile(PART_ONE_INPUT)))
    }

    /**
     * Solves part 1 of the challenge
     */
    fun part2() {
        print("Solving part 2:")
        println(part2Solution(loadFile(PART_TWO_INPUT)))
    }

    private fun loadFile(file: String): List<String>{
        val relativePath = this.javaClass.simpleName.lowercase()
        return Path(PATH_PREFIX + relativePath + file).readLines()
    }

    companion object {
        private const val PATH_PREFIX = "src/main/resources/"
        private const val EXAMPLE_PART_1_INPUT = "/ExamplePart1In.txt"
        private const val EXAMPLE_PART_1_ANSWER = "/ExamplePart1Out.txt"
        private const val EXAMPLE_PART_2_INPUT = "/ExamplePart2In.txt"
        private const val EXAMPLE_PART_2_ANSWER = "/ExamplePart2Out.txt"
        private const val PART_ONE_INPUT = "/Part1In.txt"
        private const val PART_TWO_INPUT = "/Part2In.txt"
    }

}