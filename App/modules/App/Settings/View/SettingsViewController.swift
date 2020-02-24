//
//  SettingsSettingsViewController.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 27/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import UIKit
import RxSwift
import SDWebImage

enum SettingsMenuItemType {
    case EditProfile
    case CreditCards
    case FastTrack
    case Terms
    case Help
}

struct SettingsMenuItem {
    let title: String
    let type: SettingsMenuItemType
}

class SettingsViewController: UIViewController, SettingsViewInput, EditProfileFormDelegate {
 
    var disposeBag = DisposeBag()
    var output: SettingsViewOutput!
    
    var tableView : UITableView!
    var menuItems: [SettingsMenuItem] = []
    
    var user: UserModel?

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Theme.backgroundColor
        self.title = "Indstillinger".localize()
        
        var style: UITableView.Style
        if #available(iOS 13.0, *) {
            style = .insetGrouped
        } else {
            style = .plain
        }
        
        self.tableView = UITableView(frame: self.view.bounds, style: style)
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.tableView.backgroundColor = .clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.navigationItem
            .rightBarButtonItem = UIBarButtonItem(title: "Log ud".localize(),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(logoutPressed))
        
        
        output.viewIsReady()
    }

    @objc func logoutPressed() {
        self.confirm(title: "Log ud".localize()).subscribe(onNext: { _ in
            self.output.logoutPressed()
        }).disposed(by: self.disposeBag)
    }

    // MARK: SettingsViewInput
    func setupInitialState() {
        self.menuItems = [
            SettingsMenuItem(title: "Rediger Profil".localize(), type: .EditProfile),
            SettingsMenuItem(title: "Betalingskort".localize(), type: .CreditCards),
            SettingsMenuItem(title: "Fast Track".localize(), type: .FastTrack),
            SettingsMenuItem(title: "Betingelser".localize(), type: .Terms),
            SettingsMenuItem(title: "Hjælp".localize(), type: .Help)
        ]
    }
    
    func displayError(_ error: Error) {
        self.showError(error: error).subscribe(onNext: { _ in }).disposed(by: self.disposeBag)
    }
    
    func displayUser(_ user: UserModel) {
        self.user = user
        self.tableView.reloadData()
    }
    
    func editProfileRouterFinished(user: UserModel) {
        self.dismiss(animated: true, completion: nil)
        self.displayUser(user)
    }
    
    func pickImage() {
        
        let picker = UIAlertController(title: "Skift billede".localize(), message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.addAction(UIAlertAction(title: "Kamera".localize(), style: .default, handler: { (action) in
                self.showPickerForType(.camera)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            picker.addAction(UIAlertAction(title: "Kamerarulle".localize(), style: .default, handler: { (action) in
                self.showPickerForType(.savedPhotosAlbum)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker.addAction(UIAlertAction(title: "Billedebibliotek".localize(), style: .default, handler: { (action) in
                self.showPickerForType(.photoLibrary)
            }))
        }
        
        picker.addAction(UIAlertAction(title: "Annuller".localize(), style: .cancel, handler: nil))

        self.present(picker, animated: true, completion: nil)
    }
    
    private func showPickerForType(_ type: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = type
        self.present(pickerController, animated: true, completion: nil)
    }
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        
        if let editedImage = info[.editedImage] as? UIImage {
            self.output.uploadNewAvatar(image: editedImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "MenuItem")
        }
        
        let menuItem = self.menuItems[indexPath.row]
        cell!.textLabel?.text = menuItem.title
        cell!.textLabel?.textColor = Theme.primaryTextColor
        cell!.accessoryType = .disclosureIndicator
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let container = UIView(frame: CGRect(x: 0,
                                             y: 0,
                                             width: self.view.frame.size.width,
                                             height: 300))
        
        let avatarImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 180, height: 180))
        container.addSubview(avatarImage)
        avatarImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(180)
            make.width.equalTo(180)
        }
        
        avatarImage.makeRounded()
        avatarImage.backgroundColor = .darkGray
        
        avatarImage
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] (gesture) in
                self?.pickImage()
            }).disposed(by: self.disposeBag)
        
        let label = UILabel()
        container.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(avatarImage.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
     
        
        label.textColor = Theme.primaryTextColor
        
        if let user = self.user {
            label.text = user.name
            if let urlString = user.avatarUrl, let url = URL(string: urlString) {
                avatarImage.sd_setImage(with: url,
                                        placeholderImage: nil)
            } else {
            }
        }
        
        return container
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return Bundle.main.version()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.menuItems[indexPath.row]
        self.output.menuItemPressed(item: item)
    }
}
