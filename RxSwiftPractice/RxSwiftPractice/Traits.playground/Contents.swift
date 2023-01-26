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
