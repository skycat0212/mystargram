//
//  TimeLineVC.swift
//  mystargram
//
//  Created by Kim on 2021/06/02.
//

import UIKit
import SDWebImage

class TimeLineVC: UIViewController {
    var pageCnt: Int = 0
    var articles: Array<ArticleModel> = [] {
        didSet {
            timelineTabelView.reloadData()
        }
    }
    
    @IBOutlet weak var timelineTabelView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timelineTabelView.delegate = self
        timelineTabelView.dataSource = self
        
        getArticles(pageCnt)
        
    }
    
    func getArticles(_ page: Int) {
        Network.shared.getArticlesByPage(page: page) { res in
            let articles: Array<ArticleModel>
            switch res {
            case .success(let articlesData):
                articles = articlesData
                break
            case .failure(let err):
                return
            }
            
            self.articles = articles
            
        }
    }

}

extension TimeLineVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = timelineTabelView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath) as? TimelineTableViewCell else { return UITableViewCell() }
        let article = articles[indexPath.row]
        cell.userIDLabel.text = article.writer?.username
        cell.contentTxtView.text = article.content
        
        if let imgUrl = article.imgUrl {
            let url = URL(string: imgUrl)
            cell.postImgView.sd_setImage(with: url)
        }
        
        
        
        return cell
    }
    
    
}


class TimelineTableViewCell: UITableViewCell {
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var postImgView: UIImageView!
    @IBOutlet weak var contentTxtView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
