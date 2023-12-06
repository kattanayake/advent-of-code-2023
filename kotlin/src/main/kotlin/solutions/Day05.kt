package solutions

class Day05: Day {
    override fun part1Solution(input: List<String>): String {
        val data = input[0].split(":")[1].trim().split(" ").map { it.toLong() }.toMutableList()
        val rubric = mutableMapOf<LongRange, LongRange>()

        fun doDataUpdate(){
            data.sort()
            val sortedRubric = rubric.keys.sortedBy { it.first }
            var seedIndex = 0
            var rubricIndex = 0
            while(seedIndex < data.size && rubricIndex < sortedRubric.size){
                val curRubric = sortedRubric[rubricIndex]
                val curRubricMapping = rubric[curRubric]!!
                val curSeedData = data[seedIndex]
                if(curSeedData > curRubric.last) rubricIndex++
                else {
                    // This seed falls within this range
                    if(curSeedData >= curRubric.first){
                        data[seedIndex] = curRubricMapping.first + (curSeedData - curRubric.first)
                    }
                    seedIndex++
                }
            }
        }

        input.slice(3..<input.size).forEach { line ->
                if(line.contains("map:")){ // Done parsing rubric, can map data
                    doDataUpdate()
                    rubric.clear()
                } else if(line.isNotEmpty()) {
                    val rubricParts = line.split( " ")
                    val destStart = rubricParts[0].toLong()
                    val sourceStart = rubricParts[1].toLong()
                    val rangeLength = rubricParts[2].toLong()
                    rubric[sourceStart..<(sourceStart+rangeLength)] = destStart..<(destStart+rangeLength)
                }
        }
        doDataUpdate()
        return data.min().toString()
    }

    override fun part2Solution(input: List<String>): String {
        val dataParts = input[0].split(":")[1].trim().split(" ").map { it.toLong() }
        val data = (0..<(dataParts.size/2)).map {
            val startIndex = it * 2
            val endIndex = startIndex + 1
            dataParts[startIndex]..<(dataParts[startIndex]+dataParts[endIndex])
        }.toMutableList()
        val rubric = mutableMapOf<LongRange, LongRange>()

        fun doDataUpdate(){
            data.sortBy { it.first }
            val sortedRubric = rubric.keys.sortedBy { it.first }
            var seedIndex = 0
            var rubricIndex = 0
            while(seedIndex < data.size && rubricIndex < sortedRubric.size){
                val curRubric = sortedRubric[rubricIndex]
                val curRubricMapping = rubric[curRubric]!!
                val curSeedData = data[seedIndex]
                if(curSeedData.first > (curRubric.last)){ // no overlap AND rubric < seed range
                    rubricIndex++
                } else { // Rubric not completely smaller than seed range

                    if(curSeedData.first >= curRubric.first  && curSeedData.last <= curRubric.last){
                        // Full overlap scenario
                        val newMappingStart = curRubricMapping.first + (curSeedData.first - curRubric.first)
                        val newMappingEnd = newMappingStart + curSeedData.length
                        data[seedIndex] = newMappingStart..<newMappingEnd

                    } else if (curSeedData.first >= curRubric.first && curSeedData.first <= curRubric.last){
                        // Left overlap
                        val newMappingStart = curRubricMapping.first + (curSeedData.first - curRubric.first)
                        val newMappingEnd = curRubricMapping.last + 1
                        data[seedIndex] = newMappingStart..<newMappingEnd

                        val leftoverStart = curRubric.last + 1
                        val leftoverEnd = curSeedData.last + 1
                        data.add(seedIndex+1, leftoverStart..<leftoverEnd)

                    } else if (curSeedData.last <= curRubric.last && curSeedData.last >= curRubric.first) {
                        // Right overlap
                        val newMappingStart = curRubricMapping.first
                        val newMappingEnd = newMappingStart + (curSeedData.last - curRubric.first - 1)
                        data[seedIndex] = newMappingStart..<newMappingEnd

                        val leftoverStart = curSeedData.first
                        val leftoverEnd = curRubric.first
                        data.add(seedIndex, leftoverStart..<leftoverEnd)
                        seedIndex++
                    }
                    seedIndex++
                }
            }
        }

        input.slice(3..<input.size).forEach { line ->
                if(line.contains("map:")){ // Done parsing rubric, can map data
                    doDataUpdate()
                    rubric.clear()
                } else if(line.isNotEmpty()) {
                    val rubricParts = line.split(" ")
                    val destStart = rubricParts[0].toLong()
                    val sourceStart = rubricParts[1].toLong()
                    val rangeLength = rubricParts[2].toLong()
                    rubric[sourceStart..<(sourceStart+rangeLength)] = destStart..<(destStart+rangeLength)
                }
        }
        doDataUpdate()
        return data.minByOrNull { it.first }!!.first.toString()
    }
}

private val LongRange.length
    get() = last - first + 1