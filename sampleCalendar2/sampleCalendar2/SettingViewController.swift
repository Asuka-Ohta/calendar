//
//  SettingViewController.swift
//  sampleCalendar2
//
//  Created by 太田あすか on 2017/12/09.
//  Copyright © 2017年 太田あすか. All rights reserved.
//

import UIKit

// プロトコル定義
protocol SettingTableViewControllerDelegate: class {
  func sendStampNumber(text: String)
}

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIToolbarDelegate, SettingTableViewControllerDelegate {
  
  var dailyViewController = DailyViewController()
  var settingArray = ["開始","終了", "タイトル", "メモ", "スタンプ"]
  
  var dailyViewDelegate: DailyViewControllerDelegate!
  
  var timeFormat = DateFormatter()
  var toolBar: UIToolbar!
  //var datePicker: UIDatePicker!
  
  var selectedDate: Date!
  var settingInfo: Dictionary<String, String> = [:]
  var sches: [Dictionary<String, String>] = []
  
  var stampNumber: String?
  
  var rowNumber: Int?
  
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var headerTitle: UILabel!
  @IBOutlet weak var saveScheduleBtn: UIButton!
  @IBOutlet weak var backViewBtn: UIButton!
  @IBOutlet weak var settingTable: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    settingTable.delegate = self
    settingTable.dataSource = self
    
    if (selectedDate != nil) {
      headerTitle.text = changeHeaderTitle(date: selectedDate!)
    } else {
      let today: Date = Date()
      headerTitle.text = changeHeaderTitle(date: today)
    }
    
    let schedule = UserDefaults.standard
    if (schedule.object(forKey: headerTitle.text!) != nil) {
      sches = (schedule.object(forKey: headerTitle.text!) as? [Dictionary<String, String>])!
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // headerの日を変更
  func changeHeaderTitle(date: Date) -> String {
    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = "yyyy - MM - dd"
    let selectMonth = formatter.string(from: date)
    return selectMonth
  }
  
  // sectionの数
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  // section名
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "設定"
  }

  // cellの数
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return settingArray.count
  }
  
  // cellの中身
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "set1", for: indexPath) as! SettingTableViewCell
      cell.titleLabel.text = settingArray[indexPath.row]
      cell.textField.delegate = self
      // 入力欄の設定
      cell.textField.placeholder = dateToString(date: Date())
      if settingInfo.keys.contains("開始") {
        cell.textField.text = settingInfo["開始"]
      } else {
        cell.textField.text = dateToString(date: Date())
      }
      // UIDatePickerの設定
      let datePicker = UIDatePicker()
      datePicker.addTarget(self, action: #selector(changedDateEvent(sender:)), for: UIControlEvents.valueChanged)
      datePicker.datePickerMode = UIDatePickerMode.time
      datePicker.tag = indexPath.row
      cell.textField.inputView = datePicker
      // UIToolBarの設定
      toolBar = UIToolbar(frame: CGRect(x: 0, y: Int(self.view.frame.size.height/6), width: Int(self.view.frame.size.width), height: 40))
      toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
      toolBar.barStyle = .blackTranslucent
      toolBar.tintColor = UIColor.white
      toolBar.backgroundColor = UIColor.black
      
      let toolBarBtn = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(tappedToolBarBtn(sender:)))
      let toolBarBtnToday = UIBarButtonItem(title: "今", style: .plain, target: self, action: #selector(tappedToolBarBtnNow(sender:)))
      toolBarBtnToday.tag = 10
      toolBarBtn.tag = indexPath.row
      toolBar.items = [toolBarBtn, toolBarBtnToday]
      
      cell.textField.inputAccessoryView = toolBar
      return cell
  
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "set1", for: indexPath) as! SettingTableViewCell
      cell.titleLabel.text = settingArray[indexPath.row]
      cell.textField.delegate = self
      // 入力欄の設定
      cell.textField.placeholder = dateToString(date: Date())
      if settingInfo.keys.contains("終了") {
        cell.textField.text = settingInfo["終了"]
      } else {
        cell.textField.text = dateToString(date: Date())
      }
      
      // UIDatePickerの設定
      let datePicker = UIDatePicker()
      datePicker.addTarget(self, action: #selector(changedDateEvent(sender:)), for: UIControlEvents.valueChanged)
      datePicker.datePickerMode = UIDatePickerMode.time
      datePicker.tag = indexPath.row
      cell.textField.inputView = datePicker
      // UIToolBarの設定
      toolBar = UIToolbar(frame: CGRect(x: 0, y: Int(self.view.frame.size.height/6), width: Int(self.view.frame.size.width), height: 40))
      toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
      toolBar.barStyle = .blackTranslucent
      toolBar.tintColor = UIColor.white
      toolBar.backgroundColor = UIColor.black
      
      let toolBarBtn = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(tappedToolBarBtn(sender:)))
      let toolBarBtnToday = UIBarButtonItem(title: "今", style: .plain, target: self, action: #selector(tappedToolBarBtnNow(sender:)))
      toolBarBtnToday.tag = 20
      toolBarBtn.tag = indexPath.row
      toolBar.items = [toolBarBtn, toolBarBtnToday]
      
      cell.textField.inputAccessoryView = toolBar
      return cell
      
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "set1", for: indexPath) as! SettingTableViewCell
      cell.titleLabel.text = settingArray[indexPath.row]
      cell.textField.delegate = self
      if settingInfo.keys.contains("タイトル") {
        cell.textField.text = settingInfo["タイトル"]
      }
      return cell
      
    case 3:
      let cell = tableView.dequeueReusableCell(withIdentifier: "set1", for: indexPath) as! SettingTableViewCell
      cell.titleLabel.text = settingArray[indexPath.row]
      cell.textField.delegate = self
      if settingInfo.keys.contains("メモ") {
        cell.textField.text = settingInfo["メモ"]
      }
      return cell
      
    case 4:
      let cell = tableView.dequeueReusableCell(withIdentifier: "set2", for: indexPath) as! SettingTableViewCell2
      cell.titleLabel.text = settingArray[indexPath.row]
      if stampNumber != nil {
        cell.stampImage.image = UIImage(named: "stamp" + stampNumber! + ".png")
        settingInfo["スタンプ"] = stampNumber
      }
      return cell
   
    default:
      let cell = tableView.dequeueReusableCell(withIdentifier: "set1", for: indexPath) as! SettingTableViewCell
      cell.titleLabel.text = settingArray[indexPath.row]
      return cell
    }
  }
  
  // cellの高さ
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 4 {
      return 70
    } else {
      return 50
    }
  }
  
  // 「完了」を押すと閉じる
  @objc func tappedToolBarBtn(sender: UIBarButtonItem) {
    let indexPath = IndexPath(row: sender.tag, section: 0)
    let cell = settingTable.cellForRow(at: indexPath) as! SettingTableViewCell
    cell.textField.resignFirstResponder()
    
  }
  
  // 「今」を押すと今の時間をセットする
  @objc func tappedToolBarBtnNow(sender: UIBarButtonItem) {
    var indexPath: IndexPath
    if sender.tag == 10 {
      indexPath = IndexPath(row: 0, section: 0)
    } else {
      indexPath = IndexPath(row: 1, section: 0)
    }
    let cell = settingTable.cellForRow(at: indexPath) as! SettingTableViewCell
    let now = Date()
    let picker = cell.textField.inputView as! UIDatePicker
    picker.date = now
    cell.textField.text = dateToString(date: now)
  }
  
  @objc func changedDateEvent(sender: AnyObject?){
    let indexPath = IndexPath(row: (sender?.tag)!, section: 0)
    let cell = settingTable.cellForRow(at: indexPath) as! SettingTableViewCell
    let tf = sender as! UIDatePicker
    cell.textField.text = dateToString(date: tf.date)
  }
  
  // cell タップ時
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 4 {
      let stampVC: StampViewController = self.storyboard?.instantiateViewController(withIdentifier: "stampView") as! StampViewController
      stampVC.settingTableViewDelegate = self
      self.present(stampVC, animated: true, completion: nil)
    }
  }
  
  func sendStampNumber(text: String) {
    stampNumber = text
    settingTable.reloadData()
  }
  
  // settingInfo辞書を作る
  func makeDicFromTextfield(didSelectRowAtIndexPath indexPath: IndexPath) {
    let cell1 = settingTable.cellForRow(at: indexPath) as! SettingTableViewCell
    settingInfo[cell1.titleLabel.text!] = cell1.textField.text!
  }
  
  // textfieldの編集が終わる直後に内容を格納
  func textFieldDidEndEditing(_ textField: UITextField) {
    if let cell = textField.superview?.superview as? SettingTableViewCell {
      let indexPath = self.settingTable.indexPath(for: cell)
      self.makeDicFromTextfield(didSelectRowAtIndexPath: indexPath!)
    }
  }
 
  // キーボードを閉じる
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  // Date から時間を取得
  func dateToString(date: Date) -> String {
    timeFormat.dateFormat = "HH : mm"
    return timeFormat.string(from: date)
  }
  
  // 保存ボタン
  @IBAction func tappedSaveScheduleBtn(_ sender: UIButton) {
    if settingInfo == [:] {
      self.dismiss(animated: true, completion: nil)
      return
    }
    
    // 値渡し
    let schedule = UserDefaults.standard
    if (rowNumber! < 0) {
      sches.append(settingInfo)
    } else {
      sches.remove(at: rowNumber!)
      sches.insert(settingInfo, at: rowNumber!)
    }
    schedule.set(sches, forKey: headerTitle.text!)
  }
  

  // 前の画面に戻る
  @IBAction func tappedBackViewBtn(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
}
