//
//  DailyViewController.swift
//  sampleCalendar2
//
//  Created by 太田あすか on 2017/12/08.
//  Copyright © 2017年 太田あすか. All rights reserved.
//

import UIKit

// プロトコル定義
protocol DailyViewControllerDelegate {
  func updateTableView()
}

class DailyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DailyViewControllerDelegate {

  var selectedDate: Date?
  var today: Date = Date()
  var newdate: Date?
  
  var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
  //var schedules: [Dictionary<String, String>] = []
  
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var headerTitle: UILabel!
  @IBOutlet weak var dayTable: UITableView!
  @IBOutlet weak var backViewBtn: UIButton!
  @IBOutlet weak var addScheduleBtn: UIButton!
  
  @IBAction func backToDaylyView(segue: UIStoryboardSegue) {}
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dayTable.delegate = self
    dayTable.dataSource = self
    
    if (selectedDate != nil) {
      headerTitle.text = changeHeaderTitle(date: selectedDate!)
    } else {
      headerTitle.text = changeHeaderTitle(date: today)
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    dayTable.reloadData()
  }
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
  
  /*
  // 下スワイプで monthly or weekly に戻る
  final func didSwipe(sender: UISwipeGestureRecognizer) {
    if selectedDate != nil {
      if sender.direction == .down {
        print("a")
      }
    }
  }
  */

  
  // 新しいschecellを作成
  func makeNewScheCell(start: String, end: String, name: String, memo: String) -> UITableViewCell {
    let newcell = UITableViewCell() as! DailyTableViewCell
    newcell.startTime.text = start
    newcell.endTime.text = end
    newcell.scheduleName.text = name
    newcell.scheduleMemo.text = memo
    return newcell
  }
  
  // cellタップ時
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  }
  
  // cellの中身
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "day1", for: indexPath) as! DailyTableViewCell
    let schedule = UserDefaults.standard
    let sche = schedule.object(forKey: headerTitle.text!) as! [Dictionary<String, String>]
    let s = sche[indexPath.row]
    cell.startTime.text = s["開始"]
    cell.endTime.text = s["終了"]
    cell.scheduleName.text = s["タイトル"]
    cell.scheduleMemo.text = s["メモ"]
    cell.scheduleStamp.image = UIImage(named: "stamp" + s["スタンプ"]! + ".png")
    return cell
  }
  
  // cellの数
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let schedule = UserDefaults.standard
    if (schedule.object(forKey: headerTitle.text!) == nil) {
      return 0
    }
    return (schedule.object(forKey: headerTitle.text!)! as AnyObject).count
    
  }
  
  // cellの高さ
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  // headerの日を変更
  func changeHeaderTitle(date: Date) -> String {
    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = "yyyy - MM - dd"
    let selectMonth = formatter.string(from: date)
    return selectMonth
  }

  // 予定を追加する
  @IBAction func tappedAddScheduleBtn(_ sender: UIButton) {
    let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "settingView") as! SettingViewController
    settingVC.dailyViewDelegate = self
    settingVC.selectedDate = selectedDate
    settingVC.rowNumber = -1
    self.present(settingVC, animated: true, completion: nil)
  }
  
  func updateTableView() {
    self.dayTable.reloadData()
  }
  
  // 予定編集を可能にする
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  // 編集ボタンの拡張
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let deleteBtn = UITableViewRowAction(style: .default, title: "delete"){ action, indexPath in
      let schedule = UserDefaults.standard
      var sche = schedule.object(forKey: self.headerTitle.text!) as! [Dictionary<String, String>]
      sche.remove(at: indexPath.row)
      schedule.set(sche, forKey: self.headerTitle.text!)
      self.dayTable.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
      
    }
    let editBtn = UITableViewRowAction(style: .normal, title: "edit"){ action, indexPath in
      let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "settingView") as! SettingViewController
      settingVC.dailyViewDelegate = self
      settingVC.selectedDate = self.selectedDate
      let schedule = UserDefaults.standard
      var sche = schedule.object(forKey: self.headerTitle.text!) as! [Dictionary<String, String>]
      let s = sche[indexPath.row]
      settingVC.settingInfo["開始"] = s["開始"]
      settingVC.settingInfo["終了"] = s["終了"]
      settingVC.settingInfo["タイトル"] = s["タイトル"]
      settingVC.settingInfo["メモ"] = s["メモ"]
      settingVC.stampNumber = s["スタンプ"]
      settingVC.rowNumber = indexPath.row
      //sche.remove(at: indexPath.row)
      self.present(settingVC, animated: true, completion: nil)
    }
  
    return [deleteBtn, editBtn]
  }
  
  // dailyページを閉じる
  @IBAction func tappedBackViewBtn(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
}
