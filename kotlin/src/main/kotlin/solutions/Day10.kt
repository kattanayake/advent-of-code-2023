package solutions

class Day10: Day {
    override fun part1Solution(input: List<String>): String {
        val (grid, x, y) = parseGrid(input)
        val (steps, _) = traverse(grid, x, y)
        return steps.toString()
    }

    override fun part2Solution(input: List<String>): String {
        var (grid, x, y) = parseGrid(input)
        val (_ , path) = traverse(grid, x, y)

        // Removing unnecessary pipes
        for (i in 0..<grid.size){
            for (j in 0..<grid.first().size) {
                if (i to j !in path) grid[i][j] = GridCell.GROUND
            }
        }

        grid = increaseResolution(grid)

        val frontier = mutableListOf<Pair<Int, Int>>()
        val visited = Array(grid.size){ IntArray(grid.first().size) }
        for (i in 0..<grid.size){
            if((i to 0) !in path && grid[i][0] == GridCell.GROUND){
                grid[i][0] = GridCell.UNBLOCKED
                frontier.add( i to 0)
                visited[i][0] = 1
            }
            if((i to grid.size-1) !in path && grid[i][grid.size-1] == GridCell.GROUND){
                grid[i][grid.size-1] = GridCell.UNBLOCKED
                frontier.add( i to grid.size-1)
                visited[i][grid.size-1] = 1
            }
        }
        for (i in 1..<grid.first().size){
            if((0 to i) !in path && grid[0][i] == GridCell.GROUND){
                grid[0][i] = GridCell.UNBLOCKED
                frontier.add( 0 to i)
                visited[0][i] = 1
            }
            if((0 to grid.first().size-1) !in path && grid[0][grid.first().size-1] == GridCell.GROUND){
                grid[0][grid.first().size-1] = GridCell.UNBLOCKED
                frontier.add( 0 to grid.first().size-1)
                visited[0][grid.first().size-1] = 1
            }
        }

        fun deliverFreedom(cellX: Int, cellY:Int){
            if (visited[cellX][cellY] == 1) {
                return
            }
            visited[cellX][cellY] = 1
            if (grid[cellX][cellY] != GridCell.GROUND){
                return
            }
            grid[cellX][cellY] = GridCell.UNBLOCKED
            frontier.add(cellX to cellY)
        }

        while (frontier.isNotEmpty()){
            val (cellX, cellY) = frontier.removeFirst()
            if (cellX > 0) deliverFreedom(cellX-1,cellY)
            if (cellX < grid.size - 1) deliverFreedom(cellX+1, cellY)
            if (cellY > 0) deliverFreedom(cellX, cellY-1)
            if (cellY < grid[0].size - 1) deliverFreedom(cellX, cellY+1)
        }
        var numBlocked = 0
        grid.forEachIndexed { rowIdx, row ->
            row.forEachIndexed { colIdx, gridCell ->
                if (gridCell == GridCell.GROUND && rowIdx % 2 == 0 && colIdx % 2 == 0){
                    numBlocked++
                }
            }
        }
        return numBlocked.toString()
    }

    private fun traverse(grid: MutableList<MutableList<GridCell>>, startX: Int, startY: Int): Pair<Int, MutableSet<Pair<Int, Int>>> {
        var (forwardX, forwardY) = startX to startY
        var (backwardX, backwardY) = startX to startY

        /// 0: North, 1: East, 2: South, 3: West
        var forwardDir: Int
        var backwardDir: Int
        when(grid[startX][startY]){
            GridCell.NORTH_SOUTH -> {
                forwardDir = 2
                backwardDir = 0
            }
            GridCell.EAST_WEST -> {
                forwardDir = 3
                backwardDir = 1
            }
            GridCell.NORTH_WEST -> {
                forwardDir = 3
                backwardDir = 0
            }
            GridCell.NORTH_EAST -> {
                forwardDir = 1
                backwardDir = 0
            }
            GridCell.SOUTH_WEST -> {
                forwardDir = 2
                backwardDir = 3
            }
            else -> {
                forwardDir = 2
                backwardDir = 1
            }
        }

        var steps = 0

        fun takeStep(cellX: Int, cellY: Int, direction: Int): Triple<Int, Int, Int>{
            var nextX = cellX
            var nextY = cellY

            when(direction){
                0 -> nextX -= 1
                1 -> nextY += 1
                2 -> nextX += 1
                else-> nextY -= 1
            }

            val nextDirection = when(grid[nextX][nextY]){
                GridCell.NORTH_WEST -> if (direction == 1) 0  else 3
                GridCell.NORTH_EAST -> if (direction == 3) 0  else 1
                GridCell.SOUTH_WEST -> if (direction == 1) 2  else 3
                GridCell.SOUTH_EAST -> if (direction == 3) 2  else 1
                else -> direction
            }

            return Triple(nextX, nextY, nextDirection)
        }

        val path = mutableSetOf(forwardX to forwardY)

        do {
            val forwardNext = takeStep(forwardX, forwardY, forwardDir)
            forwardX = forwardNext.first
            forwardY = forwardNext.second
            forwardDir = forwardNext.third
            val backwardNext = takeStep(backwardX, backwardY, backwardDir)
            backwardX = backwardNext.first
            backwardY = backwardNext.second
            backwardDir = backwardNext.third
            steps += 1
            path.add(forwardX to forwardY)
            path.add(backwardX to backwardY)
        } while ((forwardX != backwardX) || (forwardY != backwardY))
        return steps to path
    }

    private fun parseGrid(input: List<String>): Triple<MutableList<MutableList<GridCell>>, Int, Int> {
        var (startX, startY) = 0 to 0
        val parsedGrid = input.mapIndexed { lineIndex,  line ->
            line.mapIndexed { charIndex, c ->
                if (c == 'S') {
                    startX = lineIndex
                    startY = charIndex
                }
                GridCell.fromChar(c)
            }.toMutableList()
        }.toMutableList()

        // Replacing start with correct cell
        val above = if(startX > 0) parsedGrid[startX - 1][startY] else null
        val below = if(startX < input.size - 1){ parsedGrid[startX+1][startY]} else null
        val left = if(startY > 0){ parsedGrid[startX][startY-1]} else null
        val right = if(startY < input.size - 1){ parsedGrid[startX][startY+1]} else null

        if (above != null && setOf(GridCell.NORTH_SOUTH, GridCell.SOUTH_EAST, GridCell.SOUTH_WEST).contains(above)){
            if(left != null &&  setOf(GridCell.EAST_WEST, GridCell.SOUTH_EAST, GridCell.NORTH_EAST).contains(left)){
                parsedGrid[startX][startY] = GridCell.NORTH_WEST
            } else if (right != null && setOf(GridCell.EAST_WEST, GridCell.NORTH_WEST, GridCell.SOUTH_WEST).contains(right)){
                parsedGrid[startX][startY] = GridCell.NORTH_EAST
            } else {
                parsedGrid[startX][startY] = GridCell.NORTH_SOUTH
            }
        } else if (below != null && setOf(GridCell.NORTH_SOUTH, GridCell.NORTH_EAST, GridCell.NORTH_WEST).contains(below)){
            if (left != null && setOf(GridCell.EAST_WEST, GridCell.NORTH_EAST, GridCell.SOUTH_EAST).contains(left)){
                parsedGrid[startX][startY] = GridCell.SOUTH_WEST
            } else if(right != null && setOf(GridCell.EAST_WEST, GridCell.NORTH_WEST, GridCell.SOUTH_WEST).contains(right)){
                parsedGrid[startX][startY] = GridCell.SOUTH_EAST
            } else {
                parsedGrid[startX][startY] = GridCell.NORTH_SOUTH
            }
        } else {
            parsedGrid[startX][startY] = GridCell.EAST_WEST
        }
        return Triple(parsedGrid, startX, startY)
    }

    private fun increaseResolution( grid: List<MutableList<GridCell>>): MutableList<MutableList<GridCell>>{
        val highResolutionGrid = mutableListOf<MutableList<GridCell>>()
        for (line in grid) {
            val newLine = mutableListOf<GridCell>()
            val nextLine = mutableListOf<GridCell>()
            for (cell in line) {
                newLine.add(cell)
                if (setOf(GridCell.EAST_WEST, GridCell.NORTH_EAST, GridCell.SOUTH_EAST).contains(cell)) {
                    newLine.add(GridCell.EAST_WEST)
                } else {
                    newLine.add(GridCell.GROUND)
                }
                if (setOf(GridCell.NORTH_SOUTH, GridCell.SOUTH_EAST, GridCell.SOUTH_WEST).contains(cell)) {
                    nextLine.add(GridCell.NORTH_SOUTH)
                } else {
                    nextLine.add(GridCell.GROUND)
                }
                nextLine.add(GridCell.GROUND)
            }
            highResolutionGrid.add(newLine)
            highResolutionGrid.add(nextLine)
        }
        return highResolutionGrid
    }

    enum class GridCell(val character: Char) {
        NORTH_SOUTH('|'),
        EAST_WEST('-'),
        NORTH_WEST('J'),
        NORTH_EAST('L'),
        SOUTH_WEST('7'),
        SOUTH_EAST('F'),
        GROUND('.'),
        BLOCKED('O'),
        UNBLOCKED('X');

        companion object {
            fun fromChar(char: Char): GridCell{
                return entries.firstOrNull { it.character == char } ?: GROUND
            }
        }

        override fun toString(): String {
            return character.toString()
        }
    }
}