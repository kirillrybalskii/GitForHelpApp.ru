//
//  CustomTableViewCell.swift
//  StudentHelpApp
//
//  Created by Кирилл on 07.01.19.
//  Copyright © 2019 Кирилл. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var whatToDo: UILabel!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var deadline: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func customInit(WhatToDo: String, Subject: String, Deadline: String) {
        self.whatToDo.text = WhatToDo
        self.subject.text = Subject
        self.deadline.text = Deadline
        
        self.whatToDo.font = UIFont.boldSystemFont(ofSize: 16.0)
    }
    
}
