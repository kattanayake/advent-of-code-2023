package solutions

import helpers.Coordinate
import helpers.Direction
import kotlin.math.abs

class Day18: Day {
    override fun part1Solution(input: List<String>): String {
        val instructions = input.filter { it.isNotEmpty() }.map {
            val insParts = it.split(" ")
            val direction = when(insParts[0]){
                "L" -> Direction.LEFT
                "R" -> Direction.RIGHT
                "U" -> Direction.UP
                else -> Direction.DOWN
            }
            direction to insParts[1].toInt()
        }
        val vertices = mutableListOf(Coordinate(0, 0))
        for ((direction, steps) in instructions) {
            vertices.add(direction.takeSteps(vertices.last(), steps))
        }
        return totalArea(vertices).toString()
    }

    override fun part2Solution(input: List<String>): String {
        val instructions = input.filter { it.isNotEmpty() }.map {
            val insParts = it.split(" ")
            val direction = when(insParts[2][insParts[2].length-2]){
                '2' -> Direction.LEFT
                '0' -> Direction.RIGHT
                '3' -> Direction.UP
                else -> Direction.DOWN
            }
            direction to insParts[2].substring(2..<insParts[2].length-2).toInt(radix = 16)
        }
        val vertices = mutableListOf(Coordinate(0, 0))
        for ((direction, steps) in instructions) {
            vertices.add(direction.takeSteps(vertices.last(), steps))
        }
        return totalArea(vertices).toString()
    }

    private fun totalArea(points: List<Coordinate>): Long {
        var perimeter = 0
        for(i in 1 until points.size){
            perimeter += abs(points[i].x - points[i-1].x) + abs(points[i].y - points[i-1].y)
        }
        // https://en.m.wikipedia.org/wiki/Shoelace_formula
        var area = 0L
        for(i in 1 until points.size){
            area += (points[i-1].y.toLong() * (points[i].x - points[i-1].x))
        }

        // https://en.wikipedia.org/wiki/Pick%27s_theorem

        return area + (perimeter / 2) + 1
    }

}
