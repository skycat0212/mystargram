//
//  SignUpVC.swift
//  mystargram
//
//  Created by Kim on 2021/06/18.
//

import UIKit

class SignUpVC: UIViewController {
    var isValidId: Bool = false
    var checkedName: String = ""

    @IBOutlet weak var idTxtField: UITextField!
    @IBOutlet weak var pwTxtField: UITextField!
    @IBOutlet weak var pwCheckTxtField: UITextField!
    
    @IBOutlet weak var checkValidBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func checkValidId(_ sender: Any) {
        print(1)
        if idTxtField.text == "" {
            print(2)
            let alertController = UIAlertController(title: "ID를 입력하세요", message: nil, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okButton)
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        if idTxtField.text?.contains("/") == true || idTxtField.text?.contains(" ") == true {
            let alertController = UIAlertController(title: "특수문자나 띄어쓰기는 사용하실 수 없습니다.", message: nil, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okButton)
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        print(3)
        guard let username = idTxtField.text else { return }
        
        Network.shared.checkUserExistByUsername(username: username, completion: { isUsable in
            if isUsable == false {
                self.isValidId = false
                let alertController = UIAlertController(title: "사용 불가합니다.", message: nil, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(okButton)
                self.present(alertController, animated: true, completion: nil)
            } else {
                self.isValidId = true
                self.checkedName = username
                let alertController = UIAlertController(title: "사용 가능합니다.", message: nil, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(okButton)
                self.present(alertController, animated: true, completion: nil)
            }
            
        })
        
    }
    
    @IBAction func signUpBtnClicked(_ sender: Any) {
        if idTxtField.text == "" {
            let alertController = UIAlertController(title: "아이디 확인 해주세요.", message: nil, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okButton)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        if checkedName != idTxtField.text {
            let alertController = UIAlertController(title: "중복확인 해주세요.", message: nil, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okButton)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        if !checkPassword() {
            let alertController = UIAlertController(title: "비밀번호 확인해주세요.", message: nil, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okButton)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        guard let username = idTxtField.text, let password = pwTxtField.text else { return }
        let signUpUser: SignUpModel = SignUpModel(username: username, password: password)
        
        Network.shared.signUpRequest(user: signUpUser, completion: {
            result in
            print(result)
            switch result {
            case .success(let userData):
                
                let alertController = UIAlertController(title: "가입되었습니다.", message: nil, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "확인", style: .default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(okButton)
                self.present(alertController, animated: true, completion: nil)
                
                break
            case .failure(let err):
                
                let alertController = UIAlertController(title: "가입에 실패하였습니다.", message: nil, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(okButton)
                self.present(alertController, animated: true, completion: nil)
                
                break
            }
            
        })
        
    }
    
    func checkPassword() -> Bool {
        let pw = pwTxtField.text
        let pwCheck = pwCheckTxtField.text
        
        if pw == "" || pwCheck == "" {
            return false
        }
        return pw == pwCheck
        
    }
    



}
