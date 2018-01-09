//
//  WeeklyViewController.swift
//  sampleCalendar2
//
//  Created by 太田あすか on 2017/12/08.
//  Copyright © 2017年 太田あすか. All rights reserved.
//

import UIKit

class WeeklyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  let weekArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
  let monthArray = ["January", "February", "March", "April", "May", "Jun", "July", "August", "September", "October", "November", "December"]
  var dayArray: [Date] = []
  let holidayArray:[(month: Int, day: Int)] = [(1, 1), (2, 11), (3, 20), (4,29), (5, 3), (5, 4), (5, 5), (8, 11), (9, 23), (11,3), (11, 23), (12, 23)]
  var selectedDate: Date?
  var calendar = Calendar.current
  var dateComponents = DateComponents()
  let cellNum: Int = 750
  //var todayCount: Int = 0
  var sendDate: Date?
  
  let cellMargin: Int = 20
  let cellWidth: Int = Int(UIScreen.main.bounds.width)
  let cellHeight: Int = 150
  
  var count = 0
  
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var headerTitle: UILabel!
  @IBOutlet weak var todayBtn: UIButton!
  @IBOutlet weak var weekTable: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    weekTable.delegate = self
    weekTable.dataSource = self
    if selectedDate == nil {
      selectedDate = Date()
    }
    dayArray = getDateArray(date: selectedDate!)
    
    // データ全削除
    //let appDomain: String = Bundle.main.bundleIdentifier!
    //UserDefaults.standard.removePersistentDomain(forName: appDomain)
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
  
  // weekTable の初期位置を設定
  override func viewDidAppear(_ animated: Bool) {
    if count == 0 {
      let originCount = cellNum / 2
      let indexPath = IndexPath(row: originCount, section: 0)
      weekTable.reloadData()
      weekTable.scrollToRow(at: indexPath, at: .top, animated: false)
      count += 1
    } else {
      var selectedCount: Int = 0
      let selectedDateString = changeDateToString(date: selectedDate!)
      for i in 0 ..< cellNum {
        let dateString = changeDateToString(date: dayArray[i])
        if selectedDateString == dateString {
          selectedCount = i
          break
        }
      }
      let indexPath = IndexPath(row: selectedCount, section: 0)
      weekTable.reloadData()
      weekTable.scrollToRow(at: indexPath, at: .top, animated: false)
      }
  }
 
  // date から約２年分の Date を配列 dayArray に格納
  func getDateArray (date: Date) -> [Date] {
    var dateArray: [Date] = []
    let startDate = Date(timeInterval: TimeInterval(-43200 * cellNum), since: selectedDate!)
    for i in 0 ..< cellNum {
      let newdate = Date(timeInterval: TimeInterval(86400 * i), since: startDate)
      dateArray.append(newdate)
    }
    return dateArray
  }
  
  // cellの個数
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cellNum
  }
  
  // cellの高さ
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return CGFloat(cellHeight)
  }
  
  // cellの値
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "week1", for: indexPath) as! WeeklyTableViewCell
    let cal = Calendar(identifier: Calendar.Identifier.gregorian)
    let newdate = dayArray[indexPath.row]
    let newcom = cal.dateComponents([.weekday, .weekdayOrdinal, .month, .day], from: newdate)
    let weekday = newcom.weekday
    
    headerTitle.text = changeHeaderTitle(date: newdate)
    
    // textカラー
    if (weekday == 1) {
      cell.weekLabel!.textColor = UIColor.lightRed()
    } else if (weekday == 7) {
      cell.weekLabel!.textColor = UIColor.lightBlue()
    }
      // 祝日なら赤
    else if(holidayArray.contains{t -> Bool in t.month == newcom.month && t.day == newcom.day} == true){
      cell.weekLabel!.textColor = UIColor.lightRed()
    } else if((newcom.month == 7 && newcom.weekdayOrdinal == 3 && newcom.weekday == 2)
      || (newcom.month == 9 && newcom.weekdayOrdinal == 3 && newcom.weekday == 2)
      || (newcom.month == 10 && newcom.weekdayOrdinal == 2 && newcom.weekday == 2)){
      cell.weekLabel!.textColor = UIColor.lightRed()
    } else {
      cell.weekLabel!.textColor = UIColor.gray
    }
    
    // cellに値を入れる
    cell.weekLabel!.text = weekArray[weekday! - 1]
    cell.monthLabel!.textColor = UIColor.gray
    cell.monthLabel!.text = monthArray[newcom.month! - 1]
    cell.dayLabel!.text = String(newcom.day!)
    
    // stamp
    let schedule = UserDefaults.standard
    let key: String = changeDateToString(date: newdate)
    let sche = schedule.object(forKey: key) as? [Dictionary<String, String>]
    let scheNum = sche?.count
    cell.stamp0.image = nil
    cell.stamp1.image = nil
    cell.stamp2.image = nil
    cell.stamp3.image = nil
    cell.stamp4.image = nil
    cell.stamp5.image = nil
    cell.stamp6.image = nil
    cell.stamp7.image = nil
    if sche != nil {
      var a = 0
      while a < scheNum! {
        if a == 0 {
          cell.stamp0.image = UIImage(named: "stamp" + sche![a]["スタンプ"]! + ".png")
          a += 1
        } else if a == 1 {
          cell.stamp1.image = UIImage(named: "stamp" + sche![a]["スタンプ"]! + ".png")
          a += 1
        } else if a == 2 {
          cell.stamp2.image = UIImage(named: "stamp" + sche![a]["スタンプ"]! + ".png")
          a += 1
        } else if a == 3 {
          cell.stamp3.image = UIImage(named: "stamp" + sche![a]["スタンプ"]! + ".png")
          a += 1
        } else if a == 4 {
          cell.stamp4.image = UIImage(named: "stamp" + sche![a]["スタンプ"]! + ".png")
          a += 1
        } else if a == 5 {
          cell.stamp5.image = UIImage(named: "stamp" + sche![a]["スタンプ"]! + ".png")
          a += 1
        } else if a == 6 {
          cell.stamp6.image = UIImage(named: "stamp" + sche![a]["スタンプ"]! + ".png")
          a += 1
        } else if a == 7 {
          cell.stamp7.image = UIImage(named: "stamp" + sche![a]["スタンプ"]! + ".png")
          a += 1
        } else {
          a += 1
        }
      }
    }

    return cell
  }
  
  // スクロール開始時
  func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    //weekTable.reloadData()
  }
  // スクロール終了時
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
  //  weekTable.reloadData()
  }
  
  // cell タップ時
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    sendDate = dayArray[indexPath.row]
    selectedDate = sendDate
    performSegue(withIdentifier: "FromWeekToDay", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.identifier == "FromWeekToDay") {
      let dailyVC: DailyViewController = segue.destination as! DailyViewController
      dailyVC.selectedDate = sendDate!
    }
  }

  // headerの月を変更
  func changeHeaderTitle(date: Date) -> String {
    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = "yyyy"
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
  
  // 今日に戻る
  @IBAction func tappedTodayBtn(_ sender: UIButton) {
    let today = Date()
    var todayCount: Int = 0
    let todayString = changeDateToString(date: today)
    for i in 0 ..< cellNum {
      let dateString = changeDateToString(date: dayArray[i])
      if todayString == dateString {
        todayCount = i
        break
      }
    }
    let indexPath = IndexPath(row: todayCount, section: 0)
    weekTable.scrollToRow(at: indexPath, at: .top, animated: false)
    selectedDate = today
  }
}

