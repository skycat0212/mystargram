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
    var baseUrl = "http://localhost:8080/"
    
    enum API: String {
        case login = "user/login/"
        case signUp = "user/enroll/"
    }
  
    func loginRequest(user: LoginModel, completion: @escaping (Result<TokenModel, AFError>) -> Void) {
        let url = baseUrl + API.login.rawValue
        AF.request(url, method: .post, parameters: user, encoder: JSONParameterEncoder.default, headers: nil).validate(statusCode: 200..<300).responseDecodable(of: TokenModel.self) { res in
//            print("res : ", res)
//            print("result value : ", res.result)
            if let data = res.data {
//                print("data value : ", data)
            }
//            print("data value unwrap : ", res.data!)
            switch res.result {
            case .success(let data):
//                print("data : ", data)
                break
            case .failure(let error):
//                print("err : ", error)
                break
            }
            completion(res.result)
        }
    }
    
    func signUpRequest(user: SignUpModel, completion: @escaping (AFDataResponse<Data?>?) -> Void) {
        let url = baseUrl + API.signUp.rawValue
        AF.request(url, method: .post, parameters: user, encoder: JSONParameterEncoder.default, headers: nil).responseJSON { res in
            switch res.result {
            case .success(let data):
//                print("data : ", data)
//                print("data as String : ", data)
                break
            case .failure(let error):
//                print("err : ", error)
                break
            }
            completion(nil)
        }
    }
    
    func getArticleById(id: Int, completion: @escaping(Result<ArticleModel, AFError>) -> Void) {
        let url = baseUrl + "article/\(id)"
        guard let token = globalToken?.token else { return }
        let header: HTTPHeaders = [HTTPHeader(name: "X-AUTH-TOKEN", value: token)]
        
        AF.request(url,
                   method: .get,
                   parameters: nil as ArticleModel?,
                   encoder: JSONParameterEncoder.default,
                   headers: header).validate().responseDecodable(of: ArticleModel.self) {
                    res in
                    
//                    switch res.result {
//                    case .success(let data):
//                        completion(data as ArticleModel)
//                        break
//                    case .failure(let err):
//                        completion(err)
//                        break
////                    }
//                    print("result: \(res)")
//                    print("result data: \(res.data)")
//                    print("result data unwrap: \(res.data!)")
                    completion(res.result)
                   }
        
    }
    
    func getArticlesByPage(page: Int, completion: @escaping(Result<Array<ArticleModel>, AFError>) -> Void) {
        let url = baseUrl + "article/list/recent/" + String(page)
        guard let token = globalToken?.token else { return }
        let header: HTTPHeaders = [HTTPHeader(name: "X-AUTH-TOKEN", value: token)]
        
        AF.request(
            url,
            method: .get,
            parameters: nil as Array<ArticleModel>?,
            encoder: JSONParameterEncoder.default,
            headers: header).validate().responseDecodable(of: Array<ArticleModel>.self) {
                res in
                completion(res.result)
                
            }
        
    }
    
    func getUserArticlesByPage(userName: String, page: Int, completion: @escaping(Result<Array<ArticleModel>, AFError>) -> Void) {
        let url = baseUrl + "article/list/user/" + userName + "/page/" + String(page)
        guard let token = globalToken?.token else { return }
        let header: HTTPHeaders = [HTTPHeader(name: "X-AUTH-TOKEN", value: token)]
        
        AF.request(
            url,
            method: .get,
            parameters: nil as Array<ArticleModel>?,
            encoder: JSONParameterEncoder.default,
            headers: header).validate().responseDecodable(of: Array<ArticleModel>.self) {
                res in
                completion(res.result)
                
            }
        
    }
    
    func saveArticle(articlePack: ArticlePack, completion:@escaping(Bool) -> Void) {
        
        let url = baseUrl + "article/write"
        guard let token = globalToken?.token else { return }
        let header: HTTPHeaders = [HTTPHeader(name: "X-AUTH-TOKEN", value: token)]
        
//        print("input article : ", articlePack)
        
        AF.request(
            url,
            method: .post,
            parameters: articlePack,
            encoder: JSONParameterEncoder.default,
            headers: header).responseJSON { res in
                switch res.result {
                case .success(let data):
//                    print("data : ", data)
//                    print("data as String : ", data)
                    completion(true)
                    break
                case .failure(let error):
//                    print("err : ", error)
                    completion(false)
                    break
                }
            }
    }
    
    
    func correctArticle(article: ArticleModel, completion: @escaping(Bool)->Void) {
        
        let url = baseUrl + "article/correct/"
        guard let token = globalToken?.token else { return }
        let header: HTTPHeaders = [HTTPHeader(name: "X-AUTH-TOKEN", value: token)]
        AF.request(
            url,
            method: .put,
            parameters: article,
            encoder: JSONParameterEncoder.default,
            headers: header).responseJSON { res in
                switch res.result {
                case .success(let data):
                    completion(data as! Bool)
                    break
                case .failure(let err):
                    completion(false)
                    break
                }
            }
    }
    
    
    
}
