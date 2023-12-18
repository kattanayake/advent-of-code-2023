package helpers

data class Coordinate(val x: Int, val y: Int)

enum class Direction {
    UP, DOWN, LEFT, RIGHT;

    fun takeStep(coordinate: Coordinate) = takeSteps(coordinate, 1)

    fun takeSteps(coordinate: Coordinate, steps: Int): Coordinate {
        return when(this){
            UP -> coordinate.copy(x = coordinate.x-steps)
            DOWN -> coordinate.copy(x = coordinate.x+steps)
            LEFT -> coordinate.copy(y = coordinate.y-steps)
            RIGHT -> coordinate.copy(y = coordinate.y+steps)
        }
    }

    fun turnLeft(coordinate: Coordinate): Pair<Coordinate, Direction> {
        return when(this){
            UP -> LEFT.takeStep(coordinate) to LEFT
            DOWN -> RIGHT.takeStep(coordinate) to RIGHT
            LEFT -> DOWN.takeStep(coordinate) to DOWN
            RIGHT -> UP.takeStep(coordinate) to UP
        }
    }

    fun turnRight(coordinate: Coordinate): Pair<Coordinate, Direction> {
        return when(this){
            DOWN -> LEFT.takeStep(coordinate) to LEFT
            UP -> RIGHT.takeStep(coordinate) to RIGHT
            RIGHT -> DOWN.takeStep(coordinate) to DOWN
            LEFT -> UP.takeStep(coordinate) to UP
        }
    }
}