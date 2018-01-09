//
//  PageViewController.swift
//  sampleCalendar2
//
//  Created by 太田あすか on 2017/12/08.
//  Copyright © 2017年 太田あすか. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController , UIPageViewControllerDelegate {
  
  var monthlyViewController = MonthlyViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setViewControllers([getMonthlyView()], direction: .forward, animated: true, completion: nil)
    self.dataSource = self
    self.delegate = self
    
    let tapGesRec = self.gestureRecognizers.filter{ $0 is UITapGestureRecognizer }.first as! UITapGestureRecognizer
    let swipeGesRec = self.gestureRecognizers.filter{ $0 is UIPanGestureRecognizer }.first as! UIPanGestureRecognizer
    tapGesRec.isEnabled = false
    swipeGesRec.isEnabled = true
  }
  
  func getMonthlyView() -> MonthlyViewController {
    monthlyViewController = storyboard?.instantiateViewController(withIdentifier: "monthlyView") as! MonthlyViewController
    return monthlyViewController
  }
  
  func getWeeklyView() -> WeeklyViewController {
    return storyboard?.instantiateViewController(withIdentifier: "weeklyView") as! WeeklyViewController
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

extension PageViewController : UIPageViewControllerDataSource {

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    if viewController.isKind(of: WeeklyViewController.self) {
      let mVC = getMonthlyView()
      let vc = viewController as! WeeklyViewController
      mVC.selectedDate = vc.selectedDate
      return mVC
    } else {
      return nil
    }
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    if viewController.isKind(of: MonthlyViewController.self) {
      let wVC = getWeeklyView()
      let vc = viewController as! MonthlyViewController
      wVC.selectedDate = vc.selectedDate
      return wVC
    } else {
      return nil
    }
  }

}
