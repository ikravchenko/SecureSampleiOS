//
//  ShareViewController.swift
//  import
//
//  Created by Ivan Kravchenko on 29/10/14.
//  Copyright (c) 2014 DORMA. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
      var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
      let fileManager = NSFileManager.defaultManager()
        var error : NSError?
      let item = self.extensionContext!.inputItems.first! as NSExtensionItem
      let attachment = item.attachments!.first as NSItemProvider
      println("Input item is \(item), type is: \(_stdlib_getTypeName(item))")
      println("Input item attachment is \(attachment), type is: \(_stdlib_getTypeName(attachment))")
      //attachment.writeToFile(path.stringByAppendingPathComponent("file.png"), atomically: true)
      self.extensionContext!.completeRequestReturningItems(nil, completionHandler: nil)
    }

    override func configurationItems() -> [AnyObject]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return NSArray()
    }
  

}
