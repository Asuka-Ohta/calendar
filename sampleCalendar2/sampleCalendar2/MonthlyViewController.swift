//
//  MonthlyViewController.swift
//  sampleCalendar2
//
//  Created by 太田あすか on 2017/12/08.
//  Copyright © 2017年 太田あすか. All rights reserved.
//

import UIKit

extension UIColor {
  class func lightBlue() -> UIColor {
    return UIColor(red: 92.0 / 255, green: 192.0 / 255, blue: 210.0 / 255, alpha: 1.0)
  }
  
  class func lightRed() -> UIColor {
    return UIColor(red: 195.0 / 255, green: 123.0 / 255, blue: 175.0 / 255, alpha: 1.0)
  }
}

class MonthlyViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

  let dateManager = DateManager()
  let daysPerWeek: Int = 7
  let cellMargin: CGFloat = 0.0
  var selectedDate: Date?
  var today: Date!
  let weekArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
  var sendDate: Date?
  
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var headerTitle: UILabel!
  @IBOutlet weak var monthCollectionView: UICollectionView!
  @IBOutlet weak var prevMonthBtn: UIButton!
  @IBOutlet weak var nextMonthBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    monthCollectionView.delegate = self
    monthCollectionView.dataSource = self
    monthCollectionView.backgroundColor = UIColor.white
    
    if (selectedDate == nil) {
      selectedDate = Date()
    }
  
    headerTitle.text = changeHeaderTitle(date: selectedDate!)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    monthCollectionView.reloadData()
  }
  // section数
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }
  
  // cellの数
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if section == 0 {
      return 7
    } else {
      return dateManager.daysAcquisition()
    }
  }

  // cellの中身
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if indexPath.section == 0 {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "month2", for: indexPath) as! MonthlyCollectionViewCell2
      // textカラー
      if (indexPath.row % 7 == 0) {
        cell.dayLabel.textColor = UIColor.lightRed()
      } else if (indexPath.row % 7 == 6) {
        cell.dayLabel.textColor = UIColor.lightBlue()
      } else {
        cell.dayLabel.textColor = UIColor.gray
      }
      cell.dayLabel.text = weekArray[indexPath.row]
      cell.layer.borderColor = UIColor.gray.cgColor
      cell.layer.borderWidth = 0.25
      
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "month1", for: indexPath) as! MonthlyCollectionViewCell
      
      // textカラー
      if (indexPath.row % 7 == 0) {
        cell.dayLabel.textColor = UIColor.lightRed()
      } else if (indexPath.row % 7 == 6) {
        cell.dayLabel.textColor = UIColor.lightBlue()
      } else {
        cell.dayLabel.textColor = UIColor.gray
      }
      // text配置(その月の1~31日までしか取ってこないように)
      cell.dayLabel.text = dateManager.conversionDayFormat(indexPath: indexPath)
      // layer配置
      cell.layer.borderColor = UIColor.gray.cgColor
      cell.layer.borderWidth = 0.25
      
      // stamp
      let schedule = UserDefaults.standard
      let key: String = dateManager.changeDateToString(indexPath: indexPath)
      let sche = schedule.object(forKey: key) as? [Dictionary<String, String>]
      let scheNum = sche?.count
      cell.stamp1.image = nil
      cell.stamp2.image = nil
      if sche != nil {
        var a = 0
        while a < scheNum! {
          if a == 0 {
            cell.stamp1.image = UIImage(named: "stamp" + sche![a]["スタンプ"]! + ".png")
            a += 1
          } else if a == 1 {
            cell.stamp2.image = UIImage(named: "stamp" + sche![a]["スタンプ"]! + ".png")
            a += 1
          } else {
            a += 1
          }
        }
      }
      return cell
    }
  }
  
  // cellタップ時
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let s = dateManager.changeDateToString(indexPath: indexPath)
    if (s != "1000 - 01 - 01") {
      sendDate = dateManager.returnDate(indexPath: indexPath)
      performSegue(withIdentifier: "FromMonthToDay", sender: nil)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "FromMonthToDay" {
      let dailyVC: DailyViewController = segue.destination as! DailyViewController
      dailyVC.selectedDate = sendDate!
    }
  }
  
  // headerの月を変更
  func changeHeaderTitle(date: Date) -> String {
    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = "yyyy - MM"
    let selectMonth = formatter.string(from: date)
    return selectMonth
  }
  
  // userdefaultsにアクセスするkeyを作成
  func changeDateToString(date: Date) -> String {
    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = "yyyy - MM - dd"
    let selectMonth = formatter.string(from: date)
    return selectMonth
  }
  
  // 前月表示
  @IBAction func tappedPrevMonthBtn(_ sender: UIButton) {
    selectedDate = dateManager.prevMonth(date: selectedDate!)
    headerTitle.text = changeHeaderTitle(date: selectedDate!)
    monthCollectionView.reloadData()
  }
  
  
  // 次月表示
  @IBAction func tappedNextMonthBtn(_ sender: UIButton) {
    selectedDate = dateManager.nextMonth(date: selectedDate!)
    headerTitle.text = changeHeaderTitle(date: selectedDate!)
    monthCollectionView.reloadData()
  }
  
  // セルのサイズを設定
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let numberOfMargin: CGFloat = 8.0
    let width: CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin) / CGFloat(daysPerWeek)
    if (indexPath.section == 0) {
      let height: CGFloat = width * 0.7
      return CGSize(width: width, height: height)
    } else {
      let height: CGFloat = (collectionView.frame.size.height - cellMargin * numberOfMargin - width * 0.7) / CGFloat(dateManager.getNumberOfWeeks())
      return CGSize(width: width, height: height)
    }
  }
  
  // セルの垂直方向のマージンを設定
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return cellMargin
  }
  // セルの水平方向のマージンを設定
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return cellMargin
  }
  
}
