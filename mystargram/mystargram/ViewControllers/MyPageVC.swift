//
//  MyPageVC.swift
//  mystargram
//
//  Created by Kim on 2021/06/17.
//

import UIKit

class MyPageVC: UIViewController {
    
    var pageCnt: Int = 0
    var articles: Array<ArticleModel> = [] {
        didSet {
            articleCollectionView.reloadData()
        }
    }
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var articleCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        articleCollectionView.delegate = self
        articleCollectionView.dataSource = self
        registCell()
        setupFlowLayout()
        
        getArticles(pageCnt)
        
    }
    
    func registCell() {
        self.articleCollectionView.register(UINib(nibName: "FeedCollectionViewCell", bundle: nil) ,forCellWithReuseIdentifier: "FeedCell")
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
        self.articleCollectionView.collectionViewLayout = flowLayout
    }
    
    @IBAction func logoutBtnClicked(_ sender: Any) {
        self.tabBarController?.dismiss(animated: true, completion: nil)
    }
    
    
}


extension MyPageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = articleCollectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as? FeedCollectionViewCell else {
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
        let cellwidth = (articleCollectionView.frame.width - 4)/3
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "DetailVC") as DetailVC
        vc.articleId = articles[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}