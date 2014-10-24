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
}

