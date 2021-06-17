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

}

extension FeedVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = feedCollectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as? FeedCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let article = articles[indexPath.row]
        if let imgUrl = article.imgUrl {
            let url = URL(string: imgUrl)
            cell.feedImgView.sd_setImage(with: url)
        }
        

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellwidth = (feedCollectionView.frame.width - 6)/4
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
        
    }
}


//class FeedCollectionViewCell: UICollectionViewCell {
//    @IBOutlet weak var feedImgView: UIImageView!
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//        self.layer.cornerRadius = 15
//    }
//}
