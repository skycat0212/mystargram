//
//  TestViewController.swift
//  mystargram
//
//  Created by Kim on 2021/06/15.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var getArticleTextView: UITextView!
    @IBAction func getArticleBtnClicked(_ sender: Any) {
        Network.shared.getArticleById(id: 1) { res in
            //res: Result<ArticleModel, AFError>
            
            let article: ArticleModel
            
            switch res {
            case .success(let data):
                self.getArticleTextView.text = "\(data)"
                article = data
                break
            case .failure(let err):
                return
            }
            print("article : ", article)
            
        }
        
    }
    

}
