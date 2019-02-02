//
//  Profile+TableViewDataSource.swift
//  Project01ForZn
//
//  Created by 박종현 on 14/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

extension ProfileViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Profile.favouriteMusic.section() + 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRow = 2
        
        return numberOfRow
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == Profile.name.section() {
            if row == 0 {
                return cellForNameTitleAt()
            }else {
                return cellForNameAt()
            }
        }else if section == Profile.surname.section() {
            if row == 0 {
                return cellForSurnameTitleAt()
            }else {
                return cellForSurnameAt()
            }
        }else if section == Profile.address.section() {
            if row == 0 {
                return cellForAddressTitleAt()
            }else {
                return cellForAddressAt()
            }
        }else if section == Profile.phone.section() {
            if row == 0 {
                return cellForPhoneTitleAt()
            }else {
                return cellForPhoneAt()
            }
        }else if section == Profile.mobile.section() {
            if row == 0 {
                return cellForMobileTitleAt()
            }else {
                return cellForMobileAt()
            }
        }else if section == Profile.email.section() {
            if row == 0 {
                return cellForEmailTitleAt()
            }else {
                return cellForEmailAt()
            }
        }else if section == Profile.workAddress.section() {
            if row == 0 {
                return cellForWorkAddressTitleAt()
            }else {
                return cellForWorkAddressAt()
            }
        }else if section == Profile.workPhone.section() {
            if row == 0 {
                return cellForWorkPhoneTitleAt()
            }else {
                return cellForWorkPhoneAt()
            }
        }else if section == Profile.workEmail.section() {
            if row == 0 {
                return cellForWorkEmailTitleAt()
            }else {
                return cellForWorkEmailAt()
            }
        }else if section == Profile.favouriteFilm.section() {
            if row == 0 {
                return cellForFavouriteFilmTitleAt()
            }else {
                return cellForFavouriteFilmAt()
            }
        }else if section == Profile.favouriteBook.section() {
            if row == 0 {
                return cellForFavouriteBookTitleAt()
            }else {
                return cellForFavouriteBookAt()
            }
        }else if section == Profile.favouriteMusic.section() {
            if row == 0 {
                return cellForFavouriteMusicTitleAt()
            }else {
                return cellForFavouriteMusicAt()
            }
        }else {
            let cell:ProfileTableCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableNoneCell") as! ProfileTableCell
            return cell
        }
    }
    
    func cellForNameTitleAt() -> ProfileTableCell {
        let cell = cellForTitleAt(title: "name")
        return cell
    }
    
    func cellForNameAt() -> ProfileTableCell{
        let cell = cellForTextFieldAt(title: "name", placeholder: "Steven")
        cell.textField.text = self.profile.name
        self.nameTextField = cell.textField
        self.nameTextField.tag = Profile.name.section()
        return cell
    }
    
    func cellForSurnameTitleAt() -> ProfileTableCell {
        let cell = cellForTitleAt(title: "surname")
        return cell
    }
    
    func cellForSurnameAt() -> ProfileTableCell{
        let cell = cellForTextFieldAt(title: "surname", placeholder: "Gerrard")
        cell.textField.text = self.profile.surname
        self.surnameTextField = cell.textField
        self.surnameTextField.tag = Profile.surname.section()
        return cell
    }
    
    func cellForAddressTitleAt() -> ProfileTableCell {
        let cell = cellForTitleAt(title: "address")
        return cell
    }
    
    func cellForAddressAt() -> ProfileTableCell {
        let cell = cellForTextViewAt(placeholder: "서울특별시 중구", text: " ")
        cell.textView.text = self.profile.address
        self.addressTextView = cell.textView
        self.addressTextView.tag = Profile.address.section()
        return cell
    }
    func cellForPhoneTitleAt() -> ProfileTableCell {
        let cell = cellForTitleAt(title: "phone")
        return cell
    }
    func cellForPhoneAt() -> ProfileTableCell{
        let cell = cellForTextFieldAt(title: "phone", placeholder: "070-0000-0000")
        cell.textField.text = self.profile.phone
        self.phoneTextField = cell.textField
        self.phoneTextField.tag = Profile.phone.section()
        return cell
    }
    func cellForMobileTitleAt() -> ProfileTableCell {
        let cell = cellForTitleAt(title: "mobile")
        return cell
    }
    func cellForMobileAt() -> ProfileTableCell{
        let cell = cellForTextFieldAt(title: "mobile", placeholder: "010-0000-0000")
        cell.textField.text = self.profile.mobile
        self.mobileTextField = cell.textField
        self.mobileTextField.tag = Profile.mobile.section()
        return cell
    }
    func cellForEmailTitleAt() -> ProfileTableCell {
        let cell = cellForTitleAt(title: "Email")
        return cell
    }
    func cellForEmailAt() -> ProfileTableCell{
        let cell = cellForTextFieldAt(title: "Email", placeholder: "apple@apple.com")
        cell.textField.text = self.profile.email
        self.emailTextField = cell.textField
        self.emailTextField.tag = Profile.email.section()
        return cell
    }
    // 직장 정보
    func cellForWorkAddressTitleAt() -> ProfileTableCell {
        let cell = cellForTitleAt(title: "WorkAddress")
        return cell
    }
    func cellForWorkAddressAt() -> ProfileTableCell {
        let cell = cellForTextViewAt(placeholder: "서울특별시 중구", text: " ")
        cell.textView.text = self.profile.workAddress
        self.workaddressTextView = cell.textView
        self.workaddressTextView.tag = Profile.workAddress.section()
        return cell
    }
    func cellForWorkPhoneTitleAt() -> ProfileTableCell {
        let cell = cellForTitleAt(title: "WorkPhone")
        return cell
    }
    func cellForWorkPhoneAt() -> ProfileTableCell{
        let cell = cellForTextFieldAt(title: "WorkPhone", placeholder: "070-0000-0000")
        cell.textField.text = self.profile.workPhone
        self.workphoneTextField = cell.textField
        self.workphoneTextField.tag = Profile.workPhone.section()
        return cell
    }
    func cellForWorkEmailTitleAt() -> ProfileTableCell {
        let cell = cellForTitleAt(title: "WorkEmail")
        return cell
    }
    func cellForWorkEmailAt() -> ProfileTableCell{
        let cell = cellForTextFieldAt(title: "WorkEmail", placeholder: "apple@apple.com")
        cell.textField.text = self.profile.workEmail
        self.workemailTextField = cell.textField
        self.workemailTextField.tag = Profile.workEmail.section()
        return cell
    }
    func cellForFavouriteFilmTitleAt() -> ProfileTableCell {
        let cell = cellForTitleAt(title: "FavouriteFilm")
        return cell
    }
    func cellForFavouriteFilmAt() -> ProfileTableCell {
        let cell = cellForTextViewAt(placeholder: "서울특별시 중구", text: " ")
        cell.textView.text = self.profile.favouriteFilm
        self.favouritefilmTextView = cell.textView
        self.favouritefilmTextView.tag = Profile.favouriteFilm.section()
        return cell
    }
    func cellForFavouriteBookTitleAt() -> ProfileTableCell {
        let cell = cellForTitleAt(title: "FavouriteBook")
        return cell
    }
    func cellForFavouriteBookAt() -> ProfileTableCell {
        let cell = cellForTextViewAt(placeholder: "서울특별시 중구", text: " ")
        cell.textView.text = self.profile.favouriteBook
        self.favouritebookTextView = cell.textView
        self.favouritebookTextView.tag = Profile.favouriteBook.section()
        return cell
    }
    func cellForFavouriteMusicTitleAt() -> ProfileTableCell {
        let cell = cellForTitleAt(title: "FavouriteMusic")
        return cell
    }
    func cellForFavouriteMusicAt() -> ProfileTableCell {
        let cell = cellForTextViewAt(placeholder: "서울특별시 중구", text: " ")
        cell.textView.text = self.profile.favouriteMusic
        self.favouritemusicTextView = cell.textView
        self.favouritemusicTextView.tag = Profile.favouriteMusic.section()
        return cell
    }
    func cellForTextFieldAt(title:String, placeholder:String) -> ProfileTableCell {
        let cell:ProfileTableCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableTextFieldCell") as! ProfileTableCell
        cell.textField.font = FontManager.shared.getTextFont()
        cell.textField.placeholder = placeholder
        return cell
    }
    func cellForTitleAt(title:String) -> ProfileTableCell {
        let cell:ProfileTableCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableTitleCell") as! ProfileTableCell
        cell.titleLabel.attributedText = FontManager.shared.getTextWithFont(text: title)
        cell.titleLabel.font = FontManager.shared.getTextFont()
        return cell
    }
    func cellForTextViewAt(placeholder:String, text:String) -> ProfileTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableTextViewCell") as! ProfileTableCell
        cell.textView.attributedText = FontManager.shared.getTextWithFont(text: text)
        
        cell.textView.textContainerInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        cell.textView.font = FontManager.shared.getTextFont()
        //for i in 0..<line {
        for i in 0..<100 {
            let y = i * Int(FontManager.shared.getLineHeight())
            let width = self.view.frame.width
            let backgroundView:UIView = UIView.init(frame: CGRect.init(x: 0, y: y, width: Int(width), height: Int(FontManager.shared.getLineHeight())))
            
            let line = UIView.init(frame: CGRect.init(x: 0, y: Int(FontManager.shared.getLineHeight())-1, width: Int(width), height: 1))
            line.backgroundColor = UIColor.black
            backgroundView.addSubview(line)
            backgroundView.backgroundColor = UIColor.clear
            backgroundView.isUserInteractionEnabled = false
            cell.addSubview(backgroundView)
        }
        return cell
    }
    
    
}
