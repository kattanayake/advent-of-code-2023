package solutions

class Day13: Day {
    override fun part1Solution(input: List<String>): String {
        var answer = 0
        val rows = mutableListOf<String>()
        val columns = mutableListOf<MutableList<Char>>()

        fun validateIsMirror(data: List<String>, forwardIndex: Int, backwardsIndex: Int): Boolean{
            if (forwardIndex >= data.size || backwardsIndex < 0) return true
            if (data[forwardIndex] == data[backwardsIndex]){
                return validateIsMirror(data, forwardIndex + 1, backwardsIndex -1)
            }
            return false
        }

        (input + "").forEach{ row ->
            if (row.isNotEmpty()){
                rows.add(row)
                if (columns.isEmpty()) row.forEach { _ -> columns.add(mutableListOf()) }
                row.forEachIndexed { index, s -> columns[index].add(s) }
            } else {
                for (i in 1..<rows.size){
                    if (validateIsMirror(rows, i, i-1)){
                        answer += (i * 100)
                        break
                    }
                }
                val cols = columns.map { it.joinToString(separator = "") }
                for (i in 1..<cols.size){
                    if (validateIsMirror(cols, i, i-1)){
                        answer += i
                        break
                    }
                }
                rows.clear()
                columns.clear()
            }
        }
        return answer.toString()
    }

    override fun part2Solution(input: List<String>): String {
        var answer = 0
        val rows = mutableListOf<String>()
        val columns = mutableListOf<MutableList<Char>>()

        fun isOneOff(a: String, b: String): Boolean {
            var diff = 0
            for (i in a.indices){
                if (a[i] != b[i]) diff++
                if(diff > 1) return false
            }
            return diff == 1
        }

        fun validateIsMirror(data: List<String>, forwardIndex: Int, backwardsIndex: Int, guessUsed: Boolean = false): Boolean{
            if (forwardIndex >= data.size || backwardsIndex < 0) return guessUsed
            return if (data[forwardIndex] == data[backwardsIndex]){
                validateIsMirror(data, forwardIndex + 1, backwardsIndex -1, guessUsed)
            } else if (!guessUsed && isOneOff(data[forwardIndex], data[backwardsIndex])){
                validateIsMirror(data, forwardIndex + 1, backwardsIndex -1, true)
            } else false
        }

        (input + "").forEach{ row ->
            if (row.isNotEmpty()){
                rows.add(row)
                if (columns.isEmpty()) row.forEach { _ -> columns.add(mutableListOf()) }
                row.forEachIndexed { index, s -> columns[index].add(s) }
            } else {
                for (i in 1..<rows.size){
                    if (validateIsMirror(rows, i, i-1)){
                        answer += (i * 100)
                        break
                    }
                }
                val cols = columns.map { it.joinToString(separator = "") }
                for (i in 1..<cols.size){
                    if (validateIsMirror(cols, i, i-1)){
                        answer += i
                        break
                    }
                }
                rows.clear()
                columns.clear()
            }
        }
        return answer.toString()
    }
}