//
//  ViewController.swift
//  mystargram
//
//  Created by Kim on 2021/05/31.
//

import UIKit

var globalToken: TokenModel? = nil
var userName: String = ""
//var userId: Int = 0

class LoginVC: UIViewController {
    @IBOutlet weak var idTxtField: UITextField!
    @IBOutlet weak var pwTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginBtnClicked(_ sender: Any) {
        guard let username = idTxtField.text else { return }
        guard let password = pwTxtField.text else { return }
        
        let user = LoginModel(username: username, password: password)
        
        Network.shared.loginRequest(user: user) {
            result in
            switch result {
            case .success(let token):
                print("token hey : ", token)
                globalToken = token
                print("globalToken : ", globalToken)
                userName = username
                self.goMain()
            case .failure(let err):
                print(err)
                break
            }
        }
    }
    
    func goMain() {
        guard let vc = storyboard?.instantiateViewController(identifier: "MainTabBarController") else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}

