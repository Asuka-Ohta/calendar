//
//  MonthlyCollectionViewCell.swift
//  sampleCalendar2
//
//  Created by 太田あすか on 2017/12/08.
//  Copyright © 2017年 太田あすか. All rights reserved.
//

import UIKit

class MonthlyCollectionViewCell: UICollectionViewCell {
    
  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var stamp1: UIImageView!
  @IBOutlet weak var stamp2: UIImageView!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
}
