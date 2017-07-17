//
//  Copyright (c) 2015 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit
import Firebase
import SnapKit

@objc(SignInViewController)
class SignInViewController: UIViewController, UITextFieldDelegate {
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.text = "Personnel Database"
        label.textAlignment = .center
        label.font = UIFont(name: label.font.fontName, size: 30)
        return label
    }()
    
    let emailField: UITextField = {
        let textField = UITextField(frame: CGRect.zero)
        textField.placeholder = "Email"
        textField.setCustomStyle()
        return textField
    }()
    let passwordField: UITextField = {
        let textField = UITextField(frame: CGRect.zero)
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.setCustomStyle()
        return textField
    }()
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    let spinnerView:UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
    }()
    let signInButton: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        button.backgroundColor = .black
        button.setTitle("Sign in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
        buildConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.isLoggedIn() {
            self.signinComplete(animated: false)
        }
        ref = Database.database().reference()
    }
    
    func didTapEmailLogin(_ sender: AnyObject) {
        
        guard let email = self.emailField.text, !email.isEmpty,
            let password = self.passwordField.text, !password.isEmpty else {
            self.showMessagePrompt("email/password can't be empty")
            return
        }
        
        self.showSpinner()
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            self.hideSpinner()
            
            guard let user = user, error == nil else {
                self.showMessagePrompt(error!.localizedDescription)
                return
            }
            
            self.ref?.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                guard snapshot.exists() else {
                    self.showMessagePrompt("Email or Password is invalid.")
                    return
                }
                self.signinComplete(animated: true)
            })
        })
    }
    
    private func showSpinner() {
        spinner.startAnimating()
        spinnerView.isHidden = false
    }
    
    private func hideSpinner() {
        spinner.stopAnimating()
        spinnerView.isHidden = true
    }
    
    private func showMessagePrompt(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func buildView() {
        view.addSubview(titleLabel)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        spinnerView.addSubview(spinner)
        view.addSubview(spinnerView)
        
        signInButton.addTarget(self, action: #selector(didTapEmailLogin(_:)), for: .touchUpInside)
        view.backgroundColor = .white
        self.hideSpinner()
    }
    
    private func buildConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalToSuperview().inset(100)
        }
        emailField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(70)
            make.height.equalTo(50)
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
        }
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.left.right.equalTo(emailField)
        }
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(70)
            make.height.equalTo(50)
            make.left.right.equalTo(emailField)
        }
        spinnerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 10, height: 10))
        }
    }
    
    private func signinComplete(animated: Bool) {
        dismiss(animated: animated, completion: nil)
    }
    
    // MARK: - UIView Delegate protocol methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - UITextFieldDelegate protocol methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didTapEmailLogin(textField)
        return true
    }
}
