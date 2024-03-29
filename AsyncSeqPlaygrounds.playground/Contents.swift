import UIKit

extension URL {
    func allLines() async -> Lines {
        Lines(url: self)
    }
}

struct Lines: Sequence {
    
    let url: URL
    
    func makeIterator() -> some IteratorProtocol {
        let lines = (try? String(contentsOf: url))?.split(separator: "\n") ?? []
        return LinesIterator(lines: lines)
    }
    
}

struct LinesIterator: IteratorProtocol {
    
    typealias Element = String
    var lines: [String.SubSequence]
    
    mutating func next() -> Element? {
        if lines.isEmpty {
            return nil
        }
        return String(lines.removeFirst())
    }
}

let endpointURL = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv")!

Task {
//    for line in await endpointURL.allLines() {
    for try await line in endpointURL.lines {
        print(line)
    }
}

let url = URL(string: "https://www.google.com")!
Task {
    let (bytes, _) = try await URLSession.shared.bytes(from: url)
    for try await byte in bytes {
        print("바이트: \(byte)")
    }
}
