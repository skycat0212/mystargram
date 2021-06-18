//
//  FeedVC.swift
//  mystargram
//
//  Created by Kim on 2021/06/03.
//

import UIKit
import SDWebImage

class FeedVC: UIViewController {
    var pageCnt: Int = 0
    var articles: Array<ArticleModel> = [] {
        didSet {
            feedCollectionView.reloadData()
        }
    }
    
    @IBOutlet weak var feedCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedCollectionView.delegate = self
        feedCollectionView.dataSource = self
        registCell()
        setupFlowLayout()
        
        getArticles(pageCnt)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func registCell() {
        self.feedCollectionView.register(UINib(nibName: "FeedCollectionViewCell", bundle: nil) ,forCellWithReuseIdentifier: "FeedCell")
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
    
    private func setupFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        
        let halfWidth = UIScreen.main.bounds.width / 3
        flowLayout.itemSize = CGSize(width: halfWidth * 0.9 , height: halfWidth * 0.9)
        self.feedCollectionView.collectionViewLayout = flowLayout
    }

    @IBAction func refreshBtnClicked(_ sender: Any) {
        pageCnt = 0
        self.loadView()
        self.viewDidLoad()
    }
    
}

extension FeedVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < articles.count {
            guard let cell = feedCollectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as? FeedCollectionViewCell else {
                return UICollectionViewCell()
            }
            let article = articles[indexPath.row]
            if let imgUrl = article.imgUrl {
                let url = URL(string: imgUrl)
                cell.feedImgView.sd_setImage(with: url)
            }
            return cell
        } else {
            guard let cell = feedCollectionView.dequeueReusableCell(withReuseIdentifier: "MoreFeedCell", for: indexPath) as? FeedMoreCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        }

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellwidth = (feedCollectionView.frame.width - 4)/3
        let cellheight = cellwidth
        return CGSize(width: cellwidth, height: cellheight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < articles.count {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "DetailVC") as DetailVC
            vc.articleId = articles[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
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
                self.feedCollectionView.reloadData()
            })
        }
    }
}

class FeedMoreCollectionViewCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
    }
    
}
