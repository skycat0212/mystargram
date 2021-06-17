//
//  DetailVC.swift
//  mystargram
//
//  Created by Kim on 2021/06/17.
//

import UIKit

class DetailVC: UIViewController {
    
    enum editMode {
        case on
        case off
    }
    
    var isEditMode: editMode = .off
    
    var isMine: Bool = false {
        didSet {
            if isMine == true {
                ownerOptionView.isHidden = false
            } else {
                ownerOptionView.isHidden = true
            }
        }
    }
    
    var articleId: Int? = nil
    var article: ArticleModel? = nil {
        didSet {
            if article?.writer?.username == userName {
                isMine = true
            }
        }
    }
    
    @IBOutlet weak var ownerOptionView: UIStackView!
    
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var contentImgView: UIImageView!
    @IBOutlet weak var contentTxtView: UITextView!
    
    @IBOutlet weak var correctBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
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
    
    func setUI() {
        ownerOptionView.isHidden = !isMine
    }
    
    func setContent() {
        userIdLabel.text = article?.writer?.username
        contentTxtView.text = article?.content
        
        guard let imgUrl = article?.imgUrl else { return }
        contentImgView.sd_setImage(with: URL(string: imgUrl))
    }

    @IBAction func correctBtnClicked(_ sender: Any) {
        switch isEditMode {
        case .on: // 쓰기 모드에서 읽기 모드로 전환
            var sendArticle: ArticleModel = article!
            sendArticle.content = contentTxtView.text
            
            Network.shared.correctArticle(article: sendArticle) { didSuccess in
                switch didSuccess {
                case true:
                    self.isEditMode = .off
                    self.deleteBtn.isUserInteractionEnabled = true
                    self.contentTxtView.isEditable = false
                    self.correctBtn.setTitle("수정", for: .normal)
                    
                    let alertController = UIAlertController(title: "게시글을 수정 하였습니다.", message: nil, preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alertController.addAction(okButton)
                    self.present(alertController, animated: true, completion: nil)
                    break
                    
                case false:
                    let alertController = UIAlertController(title: "게시글 수정에 실패하였습니다.", message: nil, preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alertController.addAction(okButton)
                    self.present(alertController, animated: true, completion: nil)
                    break
                }
                
            }
            break
            
        case .off: // 읽기모드에서 쓰기 모드로 전환
            isEditMode = .on
            deleteBtn.isUserInteractionEnabled = false
            contentTxtView.isEditable = true
            correctBtn.setTitle("저장", for: .normal)
            break
        }
    }
    
    @IBAction func deleteBtnClicked(_ sender: Any) {
        Network.shared.deleteArticle(article: article!, completion: {
            didSuccess in
            switch didSuccess {
            case true:
                let alertController = UIAlertController(title: "게시글을 삭제하였습니다.", message: nil, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "확인", style: .default, handler: { [self]_ in dismissVC()})
                alertController.addAction(okButton)
                self.present(alertController, animated: true, completion: nil)
                
                break
            case false:
                let alertController = UIAlertController(title: "게시글을 삭제하지 못하였습니다.", message: nil, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(okButton)
                self.present(alertController, animated: true, completion: nil)
                break
            }
        })
    }
    
    @objc
    func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
