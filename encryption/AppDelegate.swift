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
        if url.fileURL {
            let data = NSData(contentsOfURL: url)
            let password = SSKeychain.passwordForService(ServiceName, account: "main")
            var content = NSString(data: data!, encoding: NSUTF8StringEncoding)
            if let arr = content?.componentsSeparatedByString(";") as? [String] {
                let result = arr.map({ (el : String) -> String in
                    var decrypted = CypherHelper.decryptData(NSData(base64EncodedString: el, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters), password: password)
                    if let d = decrypted {
                        return NSString(data: decrypted, encoding: NSUTF8StringEncoding) as String
                    } else {
                        return ""
                    }
                })
                UIAlertView(title: "File received", message: "Data: \(result)))", delegate: nil, cancelButtonTitle: "OK").show()
            } else {
                UIAlertView(title: "File received", message: "Cannot decrypt data", delegate: nil, cancelButtonTitle: "OK").show()
            }
        }
        return true
    }
}

