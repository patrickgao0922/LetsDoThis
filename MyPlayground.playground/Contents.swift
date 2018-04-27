//: Playground - noun: a place where people can play

import UIKit

var str = """
{"publishedAt": "2018-04-26T21:42:02Z"}
"""

struct TestCodable: Codable {
    var publishedAt:Date?
}

let data = str.data(using: .utf8)

let test = try? JSONDecoder().decode(TestCodable.self, from: data!)
print(test!.publishedAt!.hashValue)





