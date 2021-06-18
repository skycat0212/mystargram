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
    
    @IBAction func refreshBtnClicked(_ sender: Any) {
        pageCnt = 0
        self.loadView()
        self.viewDidLoad()
    }
    
}

extension TimeLineVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < articles.count {
            guard let cell = timelineTabelView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath) as? TimelineTableViewCell else { return UITableViewCell() }
            let article = articles[indexPath.row]
            cell.userIDLabel.text = article.writer?.username
            cell.contentTxtView.text = article.content
            
            if let imgUrl = article.imgUrl {
                let url = URL(string: imgUrl)
                cell.postImgView.sd_setImage(with: url)
            }
            
            return cell
        } else {
            guard let cell = timelineTabelView.dequeueReusableCell(withIdentifier: "MoreTimelineCell", for: indexPath) as? MoreTimelineCell else { return UITableViewCell() }
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != articles.count {
            return
        }
        print("clicked more cell")
        Network.shared.getArticlesByPage(page: pageCnt+1, completion: {
            res in
            print(res)
               let articles: Array<ArticleModel>
               switch res {
               case .success(let articlesData):
                print("ad", articlesData)
                   articles = articlesData
                   break
               case .failure(let err):
                print("err", err)
                   return
               }
            if articles.count == 0 {
                let alertController = UIAlertController(title: "남은 게시물이 없습니다.", message: nil, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(okButton)
                self.present(alertController, animated: true, completion: nil)
            
                return
            }
            self.articles = self.articles + articles
            self.pageCnt += 1
            self.timelineTabelView.reloadData()
        })
    }
    
    
}


class TimelineTableViewCell: UITableViewCell {
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var postImgView: UIImageView!
    @IBOutlet weak var contentTxtView: UITextView!
    
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.postImgView.layer.cornerRadius = 5
        
        self.cellView.layer.borderWidth = 1
        self.cellView.layer.cornerRadius = 5
        self.cellView.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

class MoreTimelineCell: UITableViewCell {
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.postImgView.layer.cornerRadius = 5
        
        self.cellView.layer.borderWidth = 1
        self.cellView.layer.cornerRadius = 5
        self.cellView.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
