//
//  StampViewController.swift
//  sampleCalendar2
//
//  Created by 太田あすか on 2017/12/13.
//  Copyright © 2017年 太田あすか. All rights reserved.
//

import UIKit

class StampViewController: UIViewController {

  var settingTableViewDelegate: SettingTableViewControllerDelegate!
  
  var selectedDate: Date!
  let cellMargin: Int = 20
  let scWid = Int(UIScreen.main.bounds.width)
  let scHei = Int(UIScreen.main.bounds.height)
  
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var headerTitle: UILabel!
  @IBOutlet weak var stampLabel: UILabel!
  @IBOutlet weak var backViewBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if (selectedDate != nil) {
      headerTitle.text = changeHeaderTitle(date: selectedDate!)
    } else {
      let today: Date = Date()
      headerTitle.text = changeHeaderTitle(date: today)
    }

  }
  
  override func viewDidLayoutSubviews() {
    let width = (scWid - 5 * cellMargin) / 4
    for i in 0 ..< 4 {
      for j in 0 ..< 4 {
        let imageView = UIImageView()
        let safeArea = self.view.safeAreaInsets.top
        let x = CGFloat(cellMargin * (j + 1) + width * j)
        let y = CGFloat(cellMargin * (i + 1) + width * i + 120 + Int(safeArea))
        //let safeArea = self.view.safeAreaInsets.top
        
        imageView.frame = CGRect(x: x, y: y, width: CGFloat(width), height: CGFloat(width))
        imageView.tag = 4 * i + j
        let img = UIImage(named: "stamp" + String(imageView.tag) + ".png")
        imageView.image = img
        imageView.isUserInteractionEnabled = true
        self.view.addSubview(imageView)
      }
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // headerの月を変更
  func changeHeaderTitle(date: Date) -> String {
    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = "yyyy - MM - dd"
    let selectMonth = formatter.string(from: date)
    return selectMonth
  }
  
  // タッチイベント
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    for touch: UITouch in touches {
      let tag = touch.view?.tag
      self.dismiss(animated: true, completion: {
        self.settingTableViewDelegate.sendStampNumber(text: String(tag!))
        })
    }
  }
  
  @IBAction func tappedBackViewBtn(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
}
