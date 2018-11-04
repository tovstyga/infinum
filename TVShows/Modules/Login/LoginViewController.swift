//
//  LoginViewController.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/4/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit

protocol LoginCoordinatorProtocol {
    
    func hideViewController()
    
}

protocol LoginInteractorProtocol {
    
    var model: LoginModel { get }
    
    func loginChanged(_ login: String?) -> LoginModel
    func passwordChanged(_ password: String?) -> LoginModel
    func savingEnabled(_ enabled: Bool) -> LoginModel
    
    func performLoginWithCompletion(completion: @escaping ((_ error: Error?) -> Void))
    
}

protocol LoginModel {
    var email: String? { get }
    var password: String? { get }
    var remember: Bool { get }
    var loginAvailable: Bool { get }
}

class LoginViewController: UITableViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var rememberButton: UIButton!
    @IBOutlet private weak var rememberLabel: UILabel!
    @IBOutlet private weak var showHidePasswordButton: UIButton!
    
    var interactor: LoginInteractorProtocol?
    var coordinator: LoginCoordinatorProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
        customize()
        update(interactor?.model)
    }
    
    @IBAction private func loginAction(_ sender: UIButton) {
        cancelKeyboard()
        showActivityIngicator()
        interactor?.performLoginWithCompletion(completion: { [weak self] (error) in
            guard let `self` = self else {
                return
            }
            
            self.hideActivityIndicator()
            if let _error = error {
                self.presentAlertForError(_error)
            } else {
                self.coordinator?.hideViewController()
            }
        })
    }
    
    @IBAction private func showHidePasswordAction(_ sender: UIButton) {
        cancelKeyboard()
        sender.isSelected = !sender.isSelected
        passwordTextField.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction private func rememberMeAction(_ sender: UIButton) {
        cancelKeyboard()
        update(interactor?.savingEnabled(!sender.isSelected))
    }
    
    private func localize() {
        emailTextField.placeholder = emailTextField.placeholder?.localized
        passwordTextField.placeholder = passwordTextField.placeholder?.localized
        rememberLabel.text = rememberLabel.text?.localized
        loginButton.setTitle(loginButton.title(for: .normal)?.localized, for: .normal)
    }
   
    
    private func customize() {
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func update(_ model: LoginModel?) {
        emailTextField.text = model?.email
        passwordTextField.text = model?.password
        loginButton.isEnabled = model?.loginAvailable ?? false
        rememberButton.isSelected = model?.remember ?? false
    }
    
    @IBAction private func cancelKeyboard() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

}

extension LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        if textField === emailTextField {
            update(interactor?.loginChanged(newString))
        } else if textField === passwordTextField {
            update(interactor?.passwordChanged(newString))
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
