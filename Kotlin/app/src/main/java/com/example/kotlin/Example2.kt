package com.example.kotlin

lateinit var text: String
val test : Int by lazy {
    println("초기화 중")
    100
}
fun main() {
    println("메인 함수 실행")
    println("초기화한 값 $test")
    println("두번째 호출 $test")

}
