//
//  SettingTableViewCell2.swift
//  sampleCalendar2
//
//  Created by 太田あすか on 2017/12/09.
//  Copyright © 2017年 太田あすか. All rights reserved.
//

import UIKit

class SettingTableViewCell2: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var stampImage: UIImageView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
      }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
