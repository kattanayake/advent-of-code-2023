package solutions

class Day15: Day {
    override fun part1Solution(input: List<String>): String {
        return input[0].split(",").sumOf { hash(it) }.toString()
    }

    override fun part2Solution(input: List<String>): String {
        val boxes = (0..<256).map { Box(it) }
        input[0].split(",").forEach {ins ->
            if (ins.last() == '-'){
                val label = ins.substring(0..<ins.length-1)
                val box = hash(label)
                boxes[box].remove(label)

            } else {
                val label = ins.split("=")[0]
                val focal = ins.split("=")[1].toInt()
                val box = hash(label)
                boxes[box].add(label, focal)
            }
        }
        return boxes.sumOf { it.getFocalLength() }.toString()
    }
;
    private fun hash(label: String): Int{
        var answer = 0
        label.forEach {
            answer += it.code
            answer *= 17
            answer %= 256
        }
        return answer
    }

    class Box(
        private var boxNum: Int,
        private var lenses: MutableList<Pair<String, Int>> = mutableListOf(),
        private var lensIndexes: MutableMap<String, Int> = mutableMapOf()
    ){
        fun remove(label: String){
            lensIndexes[label]?.let {
                lenses.removeAt(it)
                for (idx in it..<lenses.size){
                    lensIndexes[lenses[idx].first] = idx
                }
                lensIndexes.remove(label)
            }
        }

        fun add(lens: String, focal: Int){
            lensIndexes[lens]?.let {
                lenses[it] = lens to focal
            } ?: run {
                lenses.add(lens to focal)
                lensIndexes[lens] = lenses.size-1
            }
        }

        fun getFocalLength(): Int {
            var answer = 0
            lenses.forEachIndexed { index, (_, focal) ->
                answer += (boxNum + 1) * (index + 1) * focal
            }
            return answer
        }
    }
}