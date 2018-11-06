//
//  CommentsViewController.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/6/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit

protocol CommentsCoordinatorProtocol {
    
    func back()
    
}

protocol CommentsInteractorProtocol {
    
    var comments: [CommentCellModelProtocol] { get }
    
    func postComment(comment: String, completion: @escaping (_ error: Error?) -> Void)
    func reload(completion: @escaping (_ error: Error?) -> Void)
}

class CommentsViewController: UIViewController {
    
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var commentTextField: UITextField!
    @IBOutlet private weak var roundedView: UIView!
    @IBOutlet private weak var postButton: UIButton!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var container: UIView!
    
    var coordinator: CommentsCoordinatorProtocol?
    var interactor: CommentsInteractorProtocol?
    
    private var keyboardObserver : KBKeyboardObserver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
        customize()
        reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.keyboardObserver = self.register(forKeyboardNotifications: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.keyboardObserver = nil
    }
    
    @IBAction private func backAction() {
        coordinator?.back()
    }
    
    @IBAction func postCommentAction(_ sender: UIButton) {
        guard let comment = commentTextField.text, comment.count > 0, let _interactor = interactor else {
            return
        }
        
        commentTextField.resignFirstResponder()
        showActivityIngicator()
        tableView.isScrollEnabled = false
        
        _interactor.postComment(comment: comment) { [weak self] error in
            guard let `self` = self else { return }
            self.hideActivityIndicator()
            self.tableView.isScrollEnabled = true
            if error == nil {
                self.commentTextField.text = nil
                self.update()
            } else {
                self.presentAlertForError(error)
            }
        }
    }
    
    private func reload() {
        guard let _interactor = interactor else {
            return
        }
        
        showActivityIngicator()
        tableView.isScrollEnabled = false
        _interactor.reload { [weak self] error in
            guard let `self` = self else { return }
            
            self.hideActivityIndicator()
            self.tableView.isScrollEnabled = true
            self.update()
            self.presentAlertForError(error)
        }
    }
    
    private func update() {
        if interactor?.comments.count ?? 0 == 0 {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath.init(row: interactor!.comments.count - 1, section: 0), at: .none, animated: true)
        }
    }
    
    private func localize() {
        postButton.setTitle(postButton.title(for: .normal)?.localized, for: .normal)
        commentTextField.placeholder = commentTextField.placeholder?.localized
        infoLabel.text = infoLabel.text?.localized
    }
    
    private func customize() {
        navigationController?.navigationBar.setBackgroundImage(UIImage.from(color: .white), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let backButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        backButton.setImage(UIImage(named: "ic-navigate-back"), for: .normal)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        roundedView.layer.cornerRadius = roundedView.bounds.height / 2
        roundedView.layer.masksToBounds = true
        roundedView.layer.borderWidth = 1
        roundedView.layer.borderColor = UIColor.app.ultraLightGray.cgColor
        
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
        avatarImageView.layer.masksToBounds = true
        
        title = "Comments".localized
    }
    
}

extension CommentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        commentTextField.resignFirstResponder()
    }
    
}

extension CommentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.comments.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let _interactor = interactor else {
            return UITableViewCell()
        }
        
        return _interactor.comments[indexPath.row].dequeueCellAtIndexPath(indexPath, tableView: tableView)
    }
    
}

extension CommentsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension CommentsViewController: KBKeyboardObserverDelegate {
    
    func keyboardObserver(_ keyboardObserver: KBKeyboardObserver!, observedKeyboardWillHideTo keyboardRect: CGRect, duration: TimeInterval) {
        
        bottomConstraint.constant = 0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    func keyboardObserver(_ keyboardObserver: KBKeyboardObserver!, observedKeyboardWillShowTo keyboardRect: CGRect, duration: TimeInterval) {

        let saveAreaInset = view.bounds.maxY - container.frame.maxY
        bottomConstraint.constant = keyboardRect.height - saveAreaInset
        UIView.animate(withDuration: duration, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
            guard let _interactor = self.interactor, _interactor.comments.count > 0 else { return }
            self.tableView.scrollToRow(at: IndexPath.init(row: _interactor.comments.count - 1, section: 0), at: .none, animated: true)
        }
        
    }
    
}
