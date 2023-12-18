package solutions

import helpers.Coordinate
import helpers.Direction
import kotlin.coroutines.coroutineContext
import kotlin.math.max
import kotlin.math.min

class Day16: Day {
    private lateinit var grid: List<CharArray>
    private var cache = mutableSetOf<Pair<Coordinate, Direction>>()

    private fun traverse(coordinate: Coordinate, direction: Direction){
        if ((coordinate to direction) in cache) return
        if (coordinate.x < 0 || coordinate.x >= grid.size || coordinate.y < 0 || coordinate.y >= grid[0].size){
            return
        }
        cache.add(coordinate to direction)
        when(grid[coordinate.x][coordinate.y]){
            '\\' -> when(direction){
                Direction.UP, Direction.DOWN -> direction.turnLeft(coordinate).let { traverse(it.first, it.second) }
                Direction.RIGHT, Direction.LEFT -> direction.turnRight(coordinate).let { traverse(it.first, it.second) }
            }
            '/' -> when(direction){
                Direction.UP, Direction.DOWN -> direction.turnRight(coordinate).let { traverse(it.first, it.second) }
                Direction.RIGHT, Direction.LEFT -> direction.turnLeft(coordinate).let { traverse(it.first, it.second) }
            }
            '|' -> when(direction){
                Direction.UP, Direction.DOWN -> traverse(direction.takeStep(coordinate), direction)
                Direction.RIGHT, Direction.LEFT -> {
                    direction.turnLeft(coordinate).let { traverse(it.first, it.second) }
                    direction.turnRight(coordinate).let { traverse(it.first, it.second) }
                }
            }
            '-' -> when(direction){
                Direction.RIGHT, Direction.LEFT -> traverse(direction.takeStep(coordinate), direction)
                Direction.UP, Direction.DOWN -> {
                    direction.turnLeft(coordinate).let { traverse(it.first, it.second) }
                    direction.turnRight(coordinate).let { traverse(it.first, it.second) }
                }
            }
            else -> traverse(direction.takeStep(coordinate), direction)
        }
    }
    override fun part1Solution(input: List<String>): String {
        cache.clear()
        grid = input.filter { it.isNotEmpty() }.map { it.toCharArray() }
        traverse(Coordinate(0, 0), Direction.RIGHT)
        return cache.map { it.first }.toSet().count().toString()
    }

    override fun part2Solution(input: List<String>): String {
        var bestSoFar = 0
        cache.clear()

        fun updateBestSoFar(){
            val curMin = cache.map { it.first }.toSet().count()
            bestSoFar = max(bestSoFar, curMin)
            cache.clear()
        }

        grid = input.filter { it.isNotEmpty() }.map { it.toCharArray() }
        for (i in grid.indices){
            // Top row going down
            traverse(Coordinate(0, i), Direction.DOWN)
            updateBestSoFar()

            // Bottom row going up
            traverse(Coordinate(grid[0].size-1, i), Direction.UP)
            updateBestSoFar()
        }

        for (i in grid[0].indices){
            // First column going right
            traverse(Coordinate(i,0), Direction.RIGHT)
            updateBestSoFar()

            // Last column going left
            traverse(Coordinate( i, grid[0].size-1), Direction.LEFT)
            updateBestSoFar()
        }
        return bestSoFar.toString()
    }
}