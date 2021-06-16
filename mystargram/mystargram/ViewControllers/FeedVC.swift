//
//  FeedVC.swift
//  mystargram
//
//  Created by Kim on 2021/06/03.
//

import UIKit

class FeedVC: UIViewController {
    @IBOutlet weak var feedCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedCollectionView.delegate = self
        feedCollectionView.dataSource = self
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FeedVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = feedCollectionView.dequeueReusableCell(withReuseIdentifier: "FeedCollectionViewCell", for: indexPath) as? FeedCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellwidth = (feedCollectionView.bounds.width - 4)/3
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
}


class FeedCollectionViewCell: UICollectionViewCell {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
