//
//  TodoCell.swift
//  TodoAppTutorial
//
//  Created by JeongminKim on 2023/04/13.
//

import UIKit

class TodoCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print(#fileID, #function, #line, "- ")
    }
    
    @IBAction func onEditBtnClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func onDeleteBtnClicked(_ sender: UIButton) {
        
    }
}
