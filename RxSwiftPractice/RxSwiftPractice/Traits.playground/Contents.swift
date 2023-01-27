import RxSwift
import Foundation

let disposeBag = DisposeBag()

struct SomeJSON: Decodable {
    let name: String
}

enum JSONError: Error {
    case decodingError
}

let json1 = """
    {"name":"park"}
    """

let json2 = """
    {"my_name":"kim"}
    """

func decode(json: String) -> Single<SomeJSON> {
    Single<SomeJSON>.create { observer -> Disposable in
        guard let data = json.data(using: .utf8),
              let json = try? JSONDecoder().decode(SomeJSON.self, from: data) else {
                  observer(.failure(JSONError.decodingError))
                  return Disposables.create()
              }
        observer(.success(json))
        return Disposables.create()
    }
}

decode(json: json1)
    .subscribe {
        switch $0 {
        case .success(let json):
            print("성공 - \(json)")
        case .failure(let error):
            print("실패 - \(error)")
        }
        
    }.disposed(by: disposeBag)


let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
replaySubject.onNext("1. 여러분")
replaySubject.onNext("2. 힘내세요")
replaySubject.onNext("3. 어렵지만")

replaySubject.subscribe {
    print("첫번째 구독: \($0)")
}.disposed(by: disposeBag)

replaySubject.subscribe {
    print("두번째 구독: \($0)")
}.disposed(by: disposeBag)

replaySubject.onNext("4. 할 수 있어요")

