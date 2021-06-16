//
//  ArticleModel.swift
//  mystargram
//
//  Created by Kim on 2021/06/15.
//

import Foundation
import UIKit

//struct Article {
//    <#fields#>
//}

struct ArticleModel: Codable {
    var id: Int?
    var writer: UserModel?
    var content: String?
    var imgUrl: String?
}

struct ArticlePack: Codable {
    var article: ArticleModel?
    var articleImgData: String?
}
