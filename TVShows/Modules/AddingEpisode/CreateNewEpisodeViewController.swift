//
//  CreateNewEpisodeViewController.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/6/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit
import UITextView_Placeholder

protocol CreateNewEpisodeCoordinatorProtocol {
    
    func back(needsReload: Bool)
    
}

protocol CreateNewEpisodeInteractorProtocol {
    
    var episodeMaxNumber: Int { get }
    var seasonMaxNumber: Int { get }
    
    func publishEpisode(title: String?, info: String?, episode: Int, season: Int, imageUrl: URL, completion: @escaping ((_ error: Error?) -> Void))
    
    func publishEpisode(title: String?, info: String?, episode: Int, season: Int, image: UIImage, completion: @escaping ((_ error: Error?) -> Void))
    
}

class CreateNewEpisodeViewController: UITableViewController {
    
    var interactor: CreateNewEpisodeInteractorProtocol?
    var coordinator: CreateNewEpisodeCoordinatorProtocol?
    
    private var selectedEpisode: Int = 1 {
        didSet {
            updateEpisodeLabel()
        }
    }
    
    private var selectedSeason: Int = 1 {
        didSet {
            updateEpisodeLabel()
        }
    }
    
    private var imageUrl: NSURL?
    
    @IBOutlet private weak var uploadPhotoView: UIStackView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var seasonAndEpisodeLabel: UILabel!
    @IBOutlet private weak var seasonAndEpisodeTitleLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var uploadPhotoLabel: UILabel!
    
    @IBOutlet private var selectorView: UIView!
    private var needsShowSelector: Bool = false
    @IBOutlet private weak var pickerView: UIPickerView! {
        didSet {
            pickerView.delegate = self
            pickerView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        localize()
    }
    
    @IBAction private func closeSelectorAction(_ sender: UIBarButtonItem) {
        needsShowSelector = false
        resignFirstResponder()
    }
    
    @IBAction private func selectImageAction(_ sender: UITapGestureRecognizer) {
        self.resignFirstResponder()
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Photos".localized, style: .default, handler: {[weak self] _ in
            self?.presentImagePickerWithType(.photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Camera".localized, style: .default, handler: {[weak self] _ in
            self?.presentImagePickerWithType(.camera)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    private func presentImagePickerWithType(_ type: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = type
        
        showActivityIngicator()
        tableView.isScrollEnabled = false
        present(picker, animated: true) { [weak self] in
            self?.tableView.isScrollEnabled = true
            self?.hideActivityIndicator()
        }
    }
    
    @IBAction private func postEpisodeAction() {
        
        guard let _interactor = interactor else {
            return
        }
    
        [self, titleTextField, descriptionTextView].forEach { responser in
            responser?.resignFirstResponder()
        }
        
        let completion:((_ error: Error?) -> Void) = { [weak self]  error in
            guard let `self` = self else { return }
            self.tableView.isScrollEnabled = true
            self.hideActivityIndicator()
            self.presentAlertForError(error)
            
            if error == nil {
                let alert = UIAlertController(title: "Success!".localized, message: "New episode is published".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok".localized, style: .cancel, handler: {[weak self] _ in
                    self?.coordinator?.back(needsReload: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }

        
        if let url = imageUrl as URL? {
            showActivityIngicator()
            tableView.isScrollEnabled = false
            
            _interactor.publishEpisode(title: titleTextField.text,
                                       info: descriptionTextView.text,
                                       episode: selectedEpisode,
                                       season: selectedSeason,
                                       imageUrl: url,
                                       completion: completion)

        } else if let image = imageView.image {
            showActivityIngicator()
            tableView.isScrollEnabled = false
            
            _interactor.publishEpisode(title: titleTextField.text,
                                       info: descriptionTextView.text,
                                       episode: selectedEpisode,
                                       season: selectedSeason,
                                       image: image,
                                       completion: completion)
        } else {
            return
        }
        
        
    }
   
    @IBAction private func backAction() {
        coordinator?.back(needsReload: false)
    }
    
    override var inputView: UIView? {
        return selectorView
    }
    
    override var canBecomeFirstResponder: Bool {
        return needsShowSelector
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            needsShowSelector = true
            becomeFirstResponder()
            pickerView.selectRow(selectedSeason - 1, inComponent: 0, animated: true)
            pickerView.selectRow(selectedEpisode - 1, inComponent: 1, animated: true)
        }
    }
    private func updateEpisodeLabel() {
        seasonAndEpisodeLabel.text = "Season".localized + " \(selectedSeason), " + "Ep".localized + " \(selectedEpisode)"
    }
    
    private func localize() {

        descriptionTextView.placeholder = descriptionTextView.placeholder.localized
        uploadPhotoLabel.text = uploadPhotoLabel.text?.localized
        titleTextField.placeholder = titleTextField.placeholder?.localized
        seasonAndEpisodeTitleLabel.text = seasonAndEpisodeTitleLabel.text?.localized
        
        title = "Add episode".localized
    }
    
    private func customize() {
        
        let backButton = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: self, action: #selector(backAction))
        backButton.tintColor = UIColor.app.pink
        
        let postButton = UIBarButtonItem(title: "Add".localized, style: .plain, target: self, action: #selector(postEpisodeAction))
        postButton.tintColor = UIColor.app.pink
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = postButton
        
        updateEpisodeLabel()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage.from(color: .white), for: .default)
    }
    
}

extension CreateNewEpisodeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.resignFirstResponder()
        needsShowSelector = false
        return true
    }
    
}

extension CreateNewEpisodeViewController: UITextViewDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        needsShowSelector = false
        return true
    }
    
}

extension CreateNewEpisodeViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return interactor?.seasonMaxNumber ?? 0
        case 1:
            return interactor?.episodeMaxNumber ?? 0
        default:
            return 0
        }
    }
    
}

extension CreateNewEpisodeViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "Season".localized + " \(row + 1)"
        case 1:
            return "Episode".localized + " \(row + 1)"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedSeason = row + 1
        case 1:
            selectedEpisode = row + 1
        default:
            return
        }
    }
    
}

extension CreateNewEpisodeViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage  else {
            imageView.image = nil
            imageUrl = nil
            uploadPhotoView.isHidden = false
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? NSURL
        imageView.image = chosenImage
        uploadPhotoView.isHidden = true
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}

extension CreateNewEpisodeViewController: UINavigationControllerDelegate {
    
}
