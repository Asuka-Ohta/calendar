//
//  DateManager.swift
//  sampleCalendar2
//
//  Created by 太田あすか on 2017/12/08.
//  Copyright © 2017年 太田あすか. All rights reserved.
//

import UIKit

extension Date {
  func monthAgoDate() -> Date {
    let addValue: Int = -1
    let calendar = Calendar.current
    var comps = DateComponents()
    comps.month = addValue
    let newdate = calendar.date(byAdding: comps, to: self)
    return newdate!
  }
  
  func monthLaterDate() -> Date {
    let addValue: Int = 1
    let calendar = Calendar.current
    var comps = DateComponents()
    comps.month = addValue
    let newdate = calendar.date(byAdding: comps, to: self)
    return newdate!
  }
}

class DateManager: NSObject {
  
  var currentMonthOfDates = [Date]()
  var currentOfDates = [Date]()
  var selectedDate = Date()
  let daysPerWeek: Int = 7
  var numberOfWeeks: Int = 0
  var numberOfItems: Int!
  //var ordinalityOfFirstDay = 0
  
  //let cal = Calendar.current
  //let date = cal.date(from: DateComponents(year: 1000, month: 1, day: 1))
  
  // 月ごとのcellの数を返すメソッド
  func daysAcquisition() -> Int {
    let rangeOfWeeks = Calendar.current.range(of: .weekOfMonth, in: .month, for: firstDateOfMonth())
    // 月が持つ週の数
    numberOfWeeks = (rangeOfWeeks?.count)!
    // 週の数 * 列の数
    numberOfItems = numberOfWeeks * daysPerWeek
    return numberOfItems
  }
  
  func getNumberOfWeeks() -> Int {
    let rangeOfWeeks = Calendar.current.range(of: .weekOfMonth, in: .month, for: firstDateOfMonth())
    // 月が持つ週の数
    let numberOfWeeks = rangeOfWeeks?.count
    return numberOfWeeks!
  }
  
  
  // 月の初日を取得
  func firstDateOfMonth() -> Date {
    let cal = Calendar(identifier: Calendar.Identifier.gregorian)
    var com = cal.dateComponents([.year, .month, .day], from: selectedDate)
    com.day = 1
    let firstDateMonth = Calendar.current.date(from: com)
    return firstDateMonth!
  }
  
  // 月末の日を取得
  func lastDateOfMonth() -> Date {
    let cal = Calendar(identifier: Calendar.Identifier.gregorian)
    var com = cal.dateComponents([.year, .month, .day], from: selectedDate)
    let range = cal.range(of: .day, in: .month, for: selectedDate)
    com.day = (range?.count)!
    let lastDateMonth = Calendar.current.date(from: com)
    return lastDateMonth!
  }
  
  // １年前の日を取得
  func dateBeforeOneYear() -> Date {
    let cal = Calendar(identifier: Calendar.Identifier.gregorian)
    var com = cal.dateComponents([.year, .month, .day], from: selectedDate)
    com.year = -1
    let beforeYearDate = Calendar.current.date(from: com)
    return beforeYearDate!
  }
  
  
  // 表記する日にちの取得
  func dateForCellAtIndexPath(numberOfItems: Int) {
    //1 月の初日が週の何日目か
    let ordinalityOfFirstDay = Calendar.current.ordinality(of: .day, in: .weekOfMonth, for: firstDateOfMonth())!
    let last: Int = Calendar.current.dateComponents([.day], from: lastDateOfMonth()).day! - 1
    for i in 0 ..< numberOfItems {
      //2 月の初日 と indexPath.item番目のcellに表示する日 の差
      var dateComponents = DateComponents()
      dateComponents.day = i - (ordinalityOfFirstDay - 1)
      if (dateComponents.day! < 0 || dateComponents.day! > last) {
        let cal2 = Calendar.current
        let date = cal2.date(from: DateComponents(year: 1000, month: 1, day: 1))
        currentMonthOfDates.append(date!)
      } else {
        let date = Calendar.current.date(byAdding: dateComponents, to: firstDateOfMonth(), wrappingComponents: true)
        currentMonthOfDates.append(date!)
      }
    }
  }
  
  // 表記の変更
  func conversionDayFormat(indexPath: IndexPath) -> String {
    let s = changeDateToString(indexPath: indexPath)
    if (s == "1000 - 01 - 01") {
      return ""
    } else {
      dateForCellAtIndexPath(numberOfItems: numberOfItems)
      let formatter: DateFormatter = DateFormatter()
      formatter.dateFormat = "d"
      return formatter.string(from: currentMonthOfDates[indexPath.row])

    }
  }
  
  // userdefaultsにアクセスするkeyを作成
  func changeDateToString(indexPath: IndexPath) -> String {
    dateForCellAtIndexPath(numberOfItems: numberOfItems)
    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = "yyyy - MM - dd"
    return formatter.string(from: currentMonthOfDates[indexPath.row])
  }
  
  func returnDate(indexPath: IndexPath) -> Date {
    return currentMonthOfDates[indexPath.row]
  }
  
  // 前月の表示
  func prevMonth(date: Date) -> Date {
    currentMonthOfDates = []
    selectedDate = date.monthAgoDate()
    return selectedDate
  }
  // 次月の表示
  func nextMonth(date: Date) -> Date {
    currentMonthOfDates = []
    selectedDate = date.monthLaterDate()
    return selectedDate
  }
}

