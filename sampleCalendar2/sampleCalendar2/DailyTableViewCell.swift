//
//  DailyTableViewCell.swift
//  sampleCalendar2
//
//  Created by 太田あすか on 2017/12/08.
//  Copyright © 2017年 太田あすか. All rights reserved.
//

import UIKit

class DailyTableViewCell: UITableViewCell {

  @IBOutlet weak var startTime: UILabel!
  @IBOutlet weak var endTime: UILabel!
  @IBOutlet weak var scheduleName: UILabel!
  @IBOutlet weak var scheduleMemo: UILabel!
  @IBOutlet weak var scheduleStamp: UIImageView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
