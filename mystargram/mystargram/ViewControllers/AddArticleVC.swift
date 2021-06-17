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
        contentTxtView.layer.borderWidth = 1
        contentTxtView.layer.cornerRadius = 5
        articleImgView.layer.borderWidth = 1
        articleImgView.layer.cornerRadius = 5
        
    }
    
    //MARK: - Navigation
    
    func setNavigationController() {
        let saveBtn = UIBarButtonItem(title: "저장하기", style: .plain, target: self, action: #selector(save))
        self.navigationItem.setRightBarButton(saveBtn, animated: true)
    }
    
    @objc
    func save() {
        if contentImg == nil {
            alertSetImage()
            return
        }
        if contentTxtView.text == "" {
            alertSetText()
            return
        }
        
        var article: ArticleModel = ArticleModel(id: nil, writer: nil, content: nil)
        guard let content = contentTxtView.text else { return }
        article.content = content
        guard let image = contentImg else { return }
        
        let articlePack: ArticlePack = ArticlePack(article: article, articleImgData: image.convertToBase64())
        
        Network.shared.saveArticle(articlePack: articlePack) {
            didComplete in
            switch didComplete {
            case true:
                self.alertFinish()
                self.loadView()
                break
            case false:
                self.alertFail()
                break
            }
        }
    }
    
    func alertSetText() {
        let alertController = UIAlertController(title: "내용을 입력하세요.", message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okButton)
        self.present(alertController, animated: true, completion: nil)
    }
    func alertSetImage() {
        let alertController = UIAlertController(title: "사진을 선택하세요.", message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okButton)
        self.present(alertController, animated: true, completion: nil)
    }
    func alertFinish() {
        let alertController = UIAlertController(title: "등록되었습니다.", message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okButton)
        self.present(alertController, animated: true, completion: nil)
    }
    func alertFail() {
        let alertController = UIAlertController(title: "게시글을 등록하는데 실패하였습니다.", message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okButton)
        self.present(alertController, animated: true, completion: nil)
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
