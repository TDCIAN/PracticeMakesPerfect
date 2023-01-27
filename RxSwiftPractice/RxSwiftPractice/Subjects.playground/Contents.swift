import UIKit
import RxSwift
import Foundation

let disposeBag = DisposeBag()
let publishSubject = PublishSubject<String>()

publishSubject.onNext("1. 여러분 안녕하세요?")

let pub1 = publishSubject.subscribe(onNext: {
    print($0)
})

publishSubject.onNext("2. 들리세요?")
publishSubject.onNext("3. 안들리시나요?")

pub1.dispose()

let pub2 = publishSubject.subscribe {
    print($0)
}

publishSubject.onNext("4. 여보세요")
publishSubject.onCompleted()

publishSubject.onNext("5. 끝났나요")

pub2.dispose()

enum SubjectError: Error {
    case error1
}

let behaviorSubject = BehaviorSubject<String>(value: "0. 초기값")
behaviorSubject.onNext("1. 첫번째값")
behaviorSubject.subscribe {
    print("첫번째 구독: \($0.element)")
}.disposed(by: disposeBag)

behaviorSubject.subscribe {
    print("두번째 구독: \($0.element)")
}.disposed(by: disposeBag)
