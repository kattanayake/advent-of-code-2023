package solutions

class Day07: Day {
    override fun part1Solution(input: List<String>): String {
        val wagers = mutableListOf<Pair<Hand, Int>>()
        input.forEach { round ->
            val roundParts = round.split(" ")
            val cards = roundParts[0].map { CamelCard.create(it) }
            wagers.add(Hand(cards, HandType.fromCards(cards)) to roundParts[1].toInt() )
        }
        wagers.sortWith(
            compareBy <Pair<Hand, Int>> {it.first.type}
                .thenBy { it.first.cards[0] }
                .thenBy { it.first.cards[1] }
                .thenBy { it.first.cards[2] }
                .thenBy { it.first.cards[3] }
                .thenBy { it.first.cards[4] }
        )
        var answer = 0
        wagers.forEachIndexed { index, pair ->
            answer += (wagers.size - index) * pair.second
        }
        return answer.toString()
    }

    override fun part2Solution(input: List<String>): String {
        val wagers = mutableListOf<Pair<Hand, Int>>()
        input.forEach { round ->
            val roundParts = round.split(" ")
            val cards = roundParts[0].map { CamelCard.create(it, true) }
            wagers.add(Hand(cards, HandType.fromCards(cards, true)) to roundParts[1].toInt() )
        }
        wagers.sortWith(
            compareBy <Pair<Hand, Int>> {it.first.type}
                .thenBy { it.first.cards[0] }
                .thenBy { it.first.cards[1] }
                .thenBy { it.first.cards[2] }
                .thenBy { it.first.cards[3] }
                .thenBy { it.first.cards[4] }
        )
        var answer = 0
        wagers.forEachIndexed { index, pair ->
            answer += (wagers.size - index) * pair.second
        }
        return answer.toString()
    }

    data class Hand(val cards: List<CamelCard>, val type: HandType)

    enum class CamelCard {
        A, K, Q, J, T, NINE, EIGHT, SEVEN, SIX, FIVE, FOUR, THREE, TWO, JOKER;

        companion object {
            fun create(char: Char, isPartTwo: Boolean = false) = when(char){
                'A' -> A
                'K' -> K
                'Q'-> Q
                'J'-> if (isPartTwo) JOKER else J
                'T'-> T
                '9'-> NINE
                '8'-> EIGHT
                '7'-> SEVEN
                '6'-> SIX
                '5'-> FIVE
                '4'-> FOUR
                '3'-> THREE
                else -> TWO
            }
        }

    }

    enum class HandType {
        FIVE_OF_A_KIND, FOUR_OF_A_KIND, FULL_HOUSE, THREE_OF_A_KIND, TWO_PAIR, ONE_PAIR, HIGH_CARD;

        companion object {
            fun fromCards(cards: List<CamelCard>, isPartTwo: Boolean = false): HandType {
                val counts = mutableMapOf<CamelCard, Int>()
                cards.forEach { card ->
                    counts[card] = counts.getOrDefault(card, 0) + 1
                }
                return if (!isPartTwo) {
                    when (counts.values.max()) {
                        5 -> FIVE_OF_A_KIND
                        4 -> FOUR_OF_A_KIND
                        3 -> if (counts.keys.size == 2) FULL_HOUSE else THREE_OF_A_KIND
                        2 -> if (counts.keys.size == 3) TWO_PAIR  else ONE_PAIR
                        else -> HIGH_CARD
                    }
                } else {
                    val maxDuplicates = counts.filter { it.key != CamelCard.JOKER }.values.maxOrNull()
                    val numJokers = counts[CamelCard.JOKER]
                    when(maxDuplicates){
                        5 -> FIVE_OF_A_KIND
                        4 -> if (numJokers == 1) FIVE_OF_A_KIND else FOUR_OF_A_KIND
                        3 -> if (numJokers == 2) {
                                FIVE_OF_A_KIND
                            } else if (numJokers == 1) {
                                FOUR_OF_A_KIND
                            } else if (counts.keys.size == 2) {
                                FULL_HOUSE
                            } else {
                                THREE_OF_A_KIND
                            }
                        2 -> if (numJokers == 3) {
                            FIVE_OF_A_KIND
                            } else if (numJokers == 2) {
                                FOUR_OF_A_KIND
                            } else if (numJokers == 1) {
                                if (counts.keys.size == 3) {
                                    FULL_HOUSE
                                } else {
                                    THREE_OF_A_KIND
                                }
                            } else if (counts.keys.size == 3) {
                                TWO_PAIR
                            } else {
                                ONE_PAIR
                            }
                        1 -> when (numJokers) {
                            4 -> FIVE_OF_A_KIND
                            3 -> FOUR_OF_A_KIND
                            2 -> THREE_OF_A_KIND
                            1 -> ONE_PAIR
                            else -> HIGH_CARD
                        }
                        else -> FIVE_OF_A_KIND // All jokers case
                    }
                }
            }
        }
    }
}