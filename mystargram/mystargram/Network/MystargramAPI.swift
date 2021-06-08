//
//  MystargramAPI.swift
//  mystargram
//
//  Created by Kim on 2021/06/06.
//

import Foundation
import Alamofire

class Network {
    static let shared: Network = Network()
    let baseUrl = "http://localhost:8080/"
    
    enum API: String {
        case login = "user/login/"
        case signUp = "user/enroll/"
    }
  
    func loginRequest(user: LoginModel, completion: @escaping (Result<TokenModel, AFError>) -> Void) {
        let url = baseUrl + API.login.rawValue
        AF.request(url, method: .post, parameters: user, encoder: JSONParameterEncoder.default, headers: nil).validate(statusCode: 200..<300).responseDecodable(of: TokenModel.self) { res in
            print("res : ", res)
            print("result value : ", res.result)
            print("data value : ", res.data)
            switch res.result {
            case .success(let data):
                print("data : ", data)
                break
            case .failure(let error):
                print("err : ", error)
            }
            completion(res.result)
        }
    }
    
    func signUpRequest(user: SignUpModel, completion: @escaping (AFDataResponse<Data?>?) -> Void) {
        let url = baseUrl + API.signUp.rawValue
        AF.request(url, method: .post, parameters: user, encoder: JSONParameterEncoder.default, headers: nil).responseJSON { res in
            switch res.result {
            case .success(let data):
                print("data : ", data)
                print("data as String : ", data)
            case .failure(let error):
                print("err : ", error)
            }
            completion(nil)
        }
    }
    
    
    
}
