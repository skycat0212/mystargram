//
//  AddArticleVC.swift
//  mystargram
//
//  Created by Kim on 2021/06/15.
//

import UIKit

class AddArticleVC: UIViewController {
    
    let imagePickerController = UIImagePickerController()
    
    var contentImg: UIImage? = nil
//    var article: ArticleModel? = nil
    
    @IBOutlet weak var articleImgView: UIImageView!
    @IBOutlet weak var selectImgBtn: UIButton!
    @IBOutlet weak var contentTxtView: UITextView!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        mainScrollView.delegate = self
        
        setUI()
        setNavigationController()
        
    }
    
    //MARK: - 키보드
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }

    
    //MARK: - UI
    func setUI() {
        // set selectImgBtn UI
        selectImgBtn.layer.borderWidth = 1
        selectImgBtn.layer.cornerRadius = 5
        
    }
    
    //MARK: - Navigation
    
    func setNavigationController() {
        let saveBtn = UIBarButtonItem(title: "저장하기", style: .plain, target: self, action: #selector(save))
        self.navigationItem.setRightBarButton(saveBtn, animated: true)
    }
    
    @objc
    func save() {
        var article: ArticleModel = ArticleModel(id: nil, writer: nil, content: nil)
        guard let content = contentTxtView.text else { return }
        article.content = content
        guard let image = contentImg else { return }
        
        let articlePack: ArticlePack = ArticlePack(article: article, articleImgData: image.convertToBase64())
        print("image data : ")
        print(articlePack.articleImgData)
        
        Network.shared.saveArticle(articlePack: articlePack) {
            
        }
        
    }
    
    
    //MARK: - 이미지 선택

    @IBAction func clickImgSelectBtn(_ sender: Any) {
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
}


//MARK: - 이미지 선택
extension AddArticleVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            contentImg = image
            articleImgView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - 키보드
extension AddArticleVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
