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
        return Profile.favouriteMusic.section()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == Profile.name.section() {
            return cellForNameAt()
        }else if section == Profile.surname.section() {
            return cellForSurnameAt()
        }else if section == Profile.address.section() {
            return cellForAddressAt()
        }else if section == Profile.phone.section() {
            return cellForPhoneAt()
        }else if section == Profile.mobile.section() {
            return cellForMobileAt()
        }else if section == Profile.email.section() {
            return cellForEmailAt()
        }else {
            let cell:ProfileTableCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableNoneCell") as! ProfileTableCell
            return cell
        }
    }
    
    func cellForNameAt() -> ProfileTableCell{
        let cell:ProfileTableCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableTextFieldCell") as! ProfileTableCell
        let title = "name"
        cell.titleLabel.attributedText = FontManager.shared.getTextWithFont(text: title)
        cell.titleLabel.font = FontManager.shared.getTextFont()
        
        cell.textField.attributedText = FontManager.shared.getTextWithFont(text: "")
        cell.textField.attributedPlaceholder = FontManager.shared.getTextWithFont(text: cell.textField.placeholder!)
        cell.textField.font = FontManager.shared.getTextFont()
        
        return cell
    }
    func cellForSurnameAt() -> ProfileTableCell{
        let cell:ProfileTableCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableTextFieldCell") as! ProfileTableCell
        let title = "surname"
        cell.titleLabel.attributedText = FontManager.shared.getTextWithFont(text: title)
        cell.titleLabel.font = FontManager.shared.getTextFont()
        
        cell.textField.attributedText = FontManager.shared.getTextWithFont(text: "")
        cell.textField.attributedPlaceholder = FontManager.shared.getTextWithFont(text: cell.textField.placeholder!)
        cell.textField.font = FontManager.shared.getTextFont()
        
        return cell
    }
    func cellForAddressAt() -> ProfileTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableTextViewCell") as! ProfileTableCell
        let title = "address"
        cell.titleLabel.attributedText = FontManager.shared.getTextWithFont(text: title)
        cell.titleLabel.font = FontManager.shared.getTextFont()
        let string = "서울시 강남구 봉은사로"
        cell.textView.attributedText = FontManager.shared.getTextWithFont(text: string)
        cell.textView.font = FontManager.shared.getTextFont()
       
        cell.textView.textContainerInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        cell.textView.textContainer.lineFragmentPadding = 0
        
        // 현재 택스트뷰의 Font로 계산한 라인을 계산한다.
        let size = FontManager.shared.getTextSize(text: cell.textView.text)
        print("size : \(size.height)")
        
        let labelSize = FontManager.shared.getTextSize(text: "String")
        print("labelSize : \(labelSize.height)")
        
        let line:Int = Int(size.height/labelSize.height)
        print("line = \(line)")
        
        //for i in 0..<line {
        for i in 0..<100 {
            let y = i * 44
            let width = cell.frame.width
            let backgroundView:UIView = UIView.init(frame: CGRect.init(x: 0, y: y, width: Int(width), height: 44))
            
            let line = UIView.init(frame: CGRect.init(x: 0, y: 43, width: Int(width), height: 1))
            line.backgroundColor = UIColor.black
            backgroundView.addSubview(line)
            backgroundView.backgroundColor = UIColor.clear
            backgroundView.isUserInteractionEnabled = false
            cell.addSubview(backgroundView)
        }
        return cell
    }
    func cellForPhoneAt() -> ProfileTableCell{
        let cell:ProfileTableCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableTextFieldCell") as! ProfileTableCell
        let title = "phone"
        cell.titleLabel.attributedText = FontManager.shared.getTextWithFont(text: title)
        cell.titleLabel.font = FontManager.shared.getTextFont()
        cell.textField.attributedText = FontManager.shared.getTextWithFont(text: "")
        cell.textField.attributedPlaceholder = FontManager.shared.getTextWithFont(text: cell.textField.placeholder!)
        cell.textField.font = FontManager.shared.getTextFont()
        
        return cell
    }
    func cellForMobileAt() -> ProfileTableCell{
        let cell:ProfileTableCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableTextFieldCell") as! ProfileTableCell
        let title = "mobile"
        cell.titleLabel.attributedText = FontManager.shared.getTextWithFont(text: title)
        cell.titleLabel.font = FontManager.shared.getTextFont()
        cell.textField.attributedText = FontManager.shared.getTextWithFont(text: "")
        cell.textField.attributedPlaceholder = FontManager.shared.getTextWithFont(text: cell.textField.placeholder!)
        cell.textField.font = FontManager.shared.getTextFont()
        
        return cell
    }
    func cellForEmailAt() -> ProfileTableCell{
        let cell:ProfileTableCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableTextFieldCell") as! ProfileTableCell
        let title = "email"
        cell.titleLabel.attributedText = FontManager.shared.getTextWithFont(text: title)
        cell.titleLabel.font = FontManager.shared.getTextFont()
        
        cell.textField.attributedText = FontManager.shared.getTextWithFont(text: "")
        cell.textField.attributedPlaceholder = FontManager.shared.getTextWithFont(text: cell.textField.placeholder!)
        cell.textField.font = FontManager.shared.getTextFont()
        
        return cell
    }
    
    
}
