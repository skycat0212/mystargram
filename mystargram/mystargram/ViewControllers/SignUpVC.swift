//
//  SignUpVC.swift
//  mystargram
//
//  Created by Kim on 2021/06/18.
//

import UIKit

class SignUpVC: UIViewController {
    var isValidId: Bool = false

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
        print(3)
        guard let username = idTxtField.text else { return }
        
        Network.shared.checkUserExistByUsername(username: username, completion: { isUsable in
            if isUsable == false {
                self.isValidId = false
                let alertController = UIAlertController(title: "중복입니다.", message: nil, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(okButton)
                self.present(alertController, animated: true, completion: nil)
            } else {
                self.isValidId = true
                let alertController = UIAlertController(title: "사용 가능합니다.", message: nil, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(okButton)
                self.present(alertController, animated: true, completion: nil)
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
