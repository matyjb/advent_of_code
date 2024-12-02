import kotlin.math.absoluteValue

const val inputFile = "input.txt"
fun read(): List<List<Int>>? {
    val classLoader = object {}.javaClass.classLoader
    val inputStream = classLoader.getResource(inputFile)
    return inputStream?.readText()?.split("\n")?.map {
        it.trim().split("   ").map {
            it.toInt()
        }
    }
}

fun part1() {
    val numbers = read() ?: emptyList()

    val leftColumn = mutableListOf<Int>()
    val rightColumn = mutableListOf<Int>()

    for ((num1, num2) in numbers) {
        leftColumn.add(num1)
        rightColumn.add(num2)
    }

    leftColumn.sort()
    rightColumn.sort()

    var distancesSum = 0
    leftColumn.zip(rightColumn) {
            left, right -> distancesSum += (left - right).absoluteValue
    }
    println("PART1: $distancesSum")
}

fun part2() {
    val numbers = read() ?: emptyList()
    val counters = mutableMapOf<Int, Int>()
    for ((_, num2) in numbers) {
        counters.compute(num2) { _, v ->
            (v ?: 0) + 1
        }
    }

    var similarityScore = 0
    for ((num1) in numbers) {
        similarityScore += num1 * (counters[num1] ?: 0)
    }
    println("PART2: $similarityScore")
}

fun main() {
    part1()
    part2()
}