package com.example.kotlin
fun main() {
    val user = User("안녕")
    println(user.age)
}

open class User(open val name: String, open var age: Int = 100)

class Kid(override val name: String, override var age: Int): User(name, age)