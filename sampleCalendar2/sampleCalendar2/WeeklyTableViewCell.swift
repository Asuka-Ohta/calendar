//
//  WeeklyTableViewCell.swift
//  sampleCalendar2
//
//  Created by 太田あすか on 2017/12/08.
//  Copyright © 2017年 太田あすか. All rights reserved.
//

import UIKit

class WeeklyTableViewCell: UITableViewCell {

  @IBOutlet weak var monthLabel: UILabel!
  @IBOutlet weak var weekLabel: UILabel!
  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var stamp0: UIImageView!
  @IBOutlet weak var stamp1: UIImageView!
  @IBOutlet weak var stamp2: UIImageView!
  @IBOutlet weak var stamp3: UIImageView!
  @IBOutlet weak var stamp4: UIImageView!
  @IBOutlet weak var stamp5: UIImageView!
  @IBOutlet weak var stamp6: UIImageView!
  @IBOutlet weak var stamp7: UIImageView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
