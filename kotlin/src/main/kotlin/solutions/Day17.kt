package solutions

import helpers.Coordinate
import helpers.Direction
import helpers.NeighbourFunction
import helpers.findShortestPathByPredicate
import kotlin.math.min

class Day17: Day {

    lateinit var grid: List<CharArray>

    private fun Coordinate.isInGrid() = x >= 0 && x < grid.size && y >= 0 && y < grid[0].size

    private fun solveForDirection(
        direction: Direction,
        endFunction : (GridCellWithDirection) -> Boolean,
        neighbourFunction: NeighbourFunction<GridCellWithDirection>,
    ) = findShortestPathByPredicate(
        start = GridCellWithDirection(Coordinate(0, 0), direction = direction, 0),
        endFunction = endFunction,
        neighbours = neighbourFunction,
        cost = {_, dest -> grid[dest.coordinate.x][dest.coordinate.y].digitToInt()}
    )

    override fun part1Solution(input: List<String>): String {
        grid = input.filter { it.isNotEmpty() }.map { it.toCharArray() }
        val answer = solveForDirection(
            Direction.RIGHT,
            { it.coordinate.x == grid.size-1 && it.coordinate.y == grid[0].size-1}
        ){ cell ->
            buildList {
                if (cell.stepsInDirection < 3) {
                    val next = GridCellWithDirection(
                        cell.direction.takeStep(cell.coordinate),
                        cell.direction,
                        cell.stepsInDirection + 1
                    )
                    if (next.coordinate.isInGrid()) add(next)
                }
                cell.direction.turnRight(cell.coordinate).let {(nextCell, nextDir) ->
                    if (nextCell.isInGrid()) add(GridCellWithDirection(nextCell, nextDir, 1))
                }
                cell.direction.turnLeft(cell.coordinate).let {(nextCell, nextDir) ->
                    if (nextCell.isInGrid()) add(GridCellWithDirection(nextCell, nextDir, 1))
                }
            }
        }
        return answer.getScore().toString()
    }

    override fun part2Solution(input: List<String>): String {
        grid = input.filter { it.isNotEmpty() }.map { it.toCharArray() }

        fun neighbourFunction(cell: GridCellWithDirection) = buildList {
            if (cell.stepsInDirection < 10) {
                val next = GridCellWithDirection(
                    cell.direction.takeStep(cell.coordinate),
                    cell.direction,
                    cell.stepsInDirection + 1
                )
                if (next.coordinate.isInGrid()) add(next)
            }
            if (cell.stepsInDirection > 3) {
                cell.direction.turnRight(cell.coordinate).let { (nextCell, nextDir) ->
                    if (nextCell.isInGrid()) add(GridCellWithDirection(nextCell, nextDir, 1))
                }
                cell.direction.turnLeft(cell.coordinate).let { (nextCell, nextDir) ->
                    if (nextCell.isInGrid()) add(GridCellWithDirection(nextCell, nextDir, 1))
                }
            }
        }

        fun isEnd(cell: GridCellWithDirection) =
            cell.coordinate.x == grid.size-1 && cell.coordinate.y == grid[0].size-1 && cell.stepsInDirection > 3

        val answer = min(
            solveForDirection(Direction.RIGHT, ::isEnd, ::neighbourFunction).getScore(),
            solveForDirection(Direction.DOWN, ::isEnd, ::neighbourFunction).getScore())
        return answer.toString()
    }

    data class GridCellWithDirection(val coordinate: Coordinate, val direction: Direction, val stepsInDirection: Int)
}