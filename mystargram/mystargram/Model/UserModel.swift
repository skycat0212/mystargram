//
//  UserModel.swift
//  mystargram
//
//  Created by Kim on 2021/06/06.
//

import Foundation

struct LoginModel: Codable {
    let username: String
    let password: String
    
    
}

struct SignUpModel: Codable {
    let username: String
    let password: String
}

extension Encodable {
    func toDictionary() -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try! encoder.encode(self)
        let dictionary = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
        return dictionary
    }
}
