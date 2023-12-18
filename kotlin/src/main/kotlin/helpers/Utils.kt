package helpers

data class Coordinate(val x: Int, val y: Int)

enum class Direction {
    UP, DOWN, LEFT, RIGHT;

    fun takeStep(coordinate: Coordinate): Coordinate {
        return when(this){
            UP -> coordinate.copy(x = coordinate.x-1)
            DOWN -> coordinate.copy(x = coordinate.x+1)
            LEFT -> coordinate.copy(y = coordinate.y-1)
            RIGHT -> coordinate.copy(y = coordinate.y+1)
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