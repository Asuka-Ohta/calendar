//
//  SettingTableViewCell.swift
//  sampleCalendar2
//
//  Created by 太田あすか on 2017/12/09.
//  Copyright © 2017年 太田あすか. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var textField: UITextField!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
