//
//  AppDelegate.swift
//  encryption
//
//  Created by Ivan Kravchenko on 17/10/14.
//  Copyright (c) 2014 DORMA. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var navigationController : UINavigationController?
  
  func applicationWillResignActive(application: UIApplication) {
    navigationController?.popToRootViewControllerAnimated(false)
  }
  
  func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
    println("URL received:\(url)")
    UIAlertView(title: "File received", message: "URL: \(url)", delegate: nil, cancelButtonTitle: "OK").show()
    return true
  }
}

