package solutions

class Day19 :Day {

    private fun parse(input: List<String>): Pair<Map<String, WorkFlow>, List<Metal>> {
        val workflows = mutableMapOf<String, WorkFlow>()
        val metals = mutableListOf<Metal>()
        var parsingWorkFlows = true

        input.forEach { line ->
            if (line.isEmpty()){
                parsingWorkFlows = false
            } else if(parsingWorkFlows){
                val (name, ruleString) = line.split("{")
                val rules = ruleString.trim('}').split(",").map { rule ->
                    if (rule.contains(":")){
                        Rule.Conditional(
                            param = Param.fromChar(rule.first()),
                            isLesserThan = rule[1] == '<',
                            threshold = rule.split('<', '>',':')[1].toInt(),
                            destination = rule.split(":")[1]
                        )
                    } else {
                        Rule.Unconditional(destination = rule)
                    }
                }
                workflows[name] = (WorkFlow(rules))
            } else {
                metals.add(Metal(
                    line.trim('{', '}').split(",").associate {
                        val (param, value ) = it.split("=")
                        Param.fromChar(param.first()) to value.toInt()
                    }
                ))
            }
        }
        return workflows to metals
    }
    override fun part1Solution(input: List<String>): String {
        val (workflows, metals) = parse(input)
        val accepted = mutableListOf<Metal>()

        fun process(metal: Metal, workFlow: WorkFlow){
            fun terminate(rule: Rule){
                if (rule.destination == "A") accepted.add(metal)
                else if(rule.destination != "R") process(metal, workflows[rule.destination]!!)
            }

            for (rule in workFlow.rules) {
                when(rule){
                    is Rule.Conditional -> {
                        if (rule.isLesserThan){
                            if (metal.params[rule.param]!! < rule.threshold) {
                                terminate(rule)
                                return
                            }
                        } else {
                            if (metal.params[rule.param]!! > rule.threshold) {
                                terminate(rule)
                                return
                            }
                        }
                    }
                    is Rule.Unconditional -> {
                        terminate(rule)
                        return
                    }
                }
            }
        }

        metals.forEach { process(it, workflows["in"]!!) }

        return accepted.sumOf { it.params.values.sum() }.toString()
    }

    override fun part2Solution(input: List<String>): String {
        val (workflows, _) = parse(input)
        var answer = 0L

        fun explore(workFlow: WorkFlow, origParamRanges: ParamRanges){
            fun terminate(newRange: ParamRanges, rule: Rule){
                if (rule.destination == "A") answer += newRange.ranges.values.map { it.count().toLong() }.reduce(Long::times)
                else if(rule.destination != "R") explore(workflows[rule.destination]!!, newRange)
            }

            var curParams = origParamRanges
            for (rule in workFlow.rules) {
                when(rule){
                    is Rule.Unconditional -> terminate(curParams, rule)
                    is Rule.Conditional -> {
                        val conditionMatchedParams: ParamRanges
                        val conditionDidNotMatchParams: ParamRanges
                        if (rule.isLesserThan){
                            conditionMatchedParams = curParams.updateParam(rule.param, false, rule.threshold - 1)
                            conditionDidNotMatchParams = curParams.updateParam(rule.param, true, rule.threshold)
                        } else {
                            conditionMatchedParams = curParams.updateParam(rule.param, true, rule.threshold + 1)
                            conditionDidNotMatchParams = curParams.updateParam(rule.param, false, rule.threshold)
                        }
                        terminate(conditionMatchedParams, rule)
                        curParams = conditionDidNotMatchParams
                    }
                }
            }
        }

        explore(workflows["in"]!!, ParamRanges())
        return answer.toString()
    }

    @JvmInline
    value class WorkFlow(val rules: List<Rule>)
    @JvmInline
    value class Metal(val params: Map<Param, Int>)
    sealed class Rule(val destination: String) {
        class Conditional(
            val param: Param,
            val isLesserThan: Boolean,
            val threshold: Int,
            destination: String
        ): Rule(destination)

        class Unconditional(destination: String): Rule(destination)
    }

    @JvmInline
    value class ParamRanges(
        val ranges: Map<Param, IntRange> = Param.entries.associateWith { 1..4000 }
    )

    private fun ParamRanges.updateParam(param: Param, isMin: Boolean, newVal: Int) = ranges.entries.associate {
        it.key to if (it.key != param) it.value.first..it.value.last
        else if (isMin) newVal..it.value.last
        else it.value.first..newVal
    }.let { ParamRanges(it) }

    enum class Param {
        X,M,A,S;

        companion object {
            fun fromChar(char: Char) = Param.entries.first { it.name.lowercase().first() == char }
        }
    }
}