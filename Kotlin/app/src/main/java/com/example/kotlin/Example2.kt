package com.example.kotlin

fun main() {
    val dog = Dog(name = "해피", age = 24)

    println(dog.toString())
    println(dog.copy(age = 5))

    val cat: Cat = BlueCat()
    val result = when(cat) {
        is BlueCat -> "blue"
        is RedCat -> "red"
        is GreenCat -> "green"
        else -> "none"
    }

    println(result)
}

data class Dog(
    val name: String,
    val age: Int
) {
    override fun toString(): String {
        return "직접 구현 ${name}는 ${age}살임"
    }
}

sealed class Cat
class BlueCat: Cat()
class RedCat: Cat()
class GreenCat: Cat()