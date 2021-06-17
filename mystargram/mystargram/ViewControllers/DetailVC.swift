//
//  DetailVC.swift
//  mystargram
//
//  Created by Kim on 2021/06/17.
//

import UIKit

class DetailVC: UIViewController {
    
    var articleId: Int? = nil
    var article: ArticleModel? = nil
    
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var contentImgView: UIImageView!
    @IBOutlet weak var contentTxtView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getArticle()
    }
    
    func getArticle() {
        guard let articleId = articleId else {
            return
        }
        Network.shared.getArticleById(id: articleId, completion: {
            result in
            switch result {
            case .success(let articleData):
                self.article = articleData
                break
            case .failure(let err):
                return
            }
            self.setContent()
            
        })
    }
    
    func setContent() {
        userIdLabel.text = article?.writer?.username
        contentTxtView.text = article?.content
        
        guard let imgUrl = article?.imgUrl else { return }
        contentImgView.sd_setImage(with: URL(string: imgUrl))
    }


}
