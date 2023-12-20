package solutions

import helpers.lowestCommonMultiple

class Day20: Day {

    private fun parseInput(input: List<String>): Map<String, Module>{
        val modules = input.associate { modDef ->
            val (nameString, output) = modDef.split("->")
            val name = nameString.trim('&', ' ', '%')
            val outputs = output.split(",").map { it.trim() }
            name to when (nameString[0]) {
                '&' -> Module.Conjunction(outputs)
                '%' -> Module.FlipFlop(outputs)
                else -> Module.Broadcaster(outputs)
            }
        }
        modules.forEach {(name, source) ->
            source.outputs.forEach {
                (modules[it] as? Module.Conjunction)?.history?.set(name, false)
            }
        }

        return modules
    }

    private fun solve(modules: Map<String, Module>, isPartTwo: Boolean = false): Long {
        var lowPulses = 0L
        var highPulses = 0L

        val cycles = mutableMapOf<String, Long>()
        val cycleLengths = mutableMapOf<String, Long>()

        // The conjunction that powers the target
        val target = (modules["zg"] as? Module.Conjunction)?.history?.size

        if(isPartTwo && target == null) return 0L

        fun solvePartTwo(source: String, cycle: Int) : Long? {
            cycles[source]?.let { prevCycle ->
                cycleLengths[source] = cycle - prevCycle
            }
            cycles[source] = cycle.toLong()
            if (cycleLengths.size == target) {
                var ans = 1L
                for (cycleLength in cycleLengths.values) {
                    ans = lowestCommonMultiple(ans, cycleLength)
                }
                return ans
            }
            return null
        }

        repeat(if(isPartTwo) Int.MAX_VALUE else 1000){ iteration ->
            val pulses = mutableListOf(Triple("button", false, "broadcaster"))
            while (pulses.isNotEmpty()){
                val (source, pulse, dest) = pulses.removeFirst()
                if (pulse) highPulses++ else lowPulses++

                when(val module = modules[dest]){
                    is Module.Broadcaster -> module.outputs.forEach { pulses.add(Triple(dest, pulse, it)) }
                    is Module.Conjunction -> {
                        module.history[source] = pulse
                        module.outputs.forEach { out -> pulses.add(Triple(dest, !module.history.values.all { it }, out)) }
                        if (isPartTwo && dest == "zg" && pulse){
                            solvePartTwo(source, iteration + 1)?.let {
                                return it
                            }
                        }
                    }
                    is Module.FlipFlop -> {
                        if (!pulse){
                            module.enabled = module.enabled.not()
                            module.outputs.forEach { pulses.add(Triple(dest, module.enabled, it)) }
                        }
                    }
                    null -> continue
                }
            }
        }
        return lowPulses * highPulses
    }

    override fun part1Solution(input: List<String>): String {
        return solve(parseInput(input)).toString()
    }

    override fun part2Solution(input: List<String>): String {
        return solve(parseInput(input), true).toString()
    }

    sealed interface Module {
        val outputs: List<String>

        data class FlipFlop(override val outputs: List<String>, var enabled: Boolean = false): Module
        data class Conjunction(
            override val outputs: List<String>,
            var history: MutableMap<String, Boolean> = mutableMapOf()
        ): Module
        data class Broadcaster(override val outputs: List<String>): Module
    }

}
