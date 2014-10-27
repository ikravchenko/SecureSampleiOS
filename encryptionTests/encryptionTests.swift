//
//  encryptionTests.swift
//  encryptionTests
//
//  Created by Ivan Kravchenko on 17/10/14.
//  Copyright (c) 2014 DORMA. All rights reserved.
//

import UIKit
import XCTest
import Security
import Foundation

let KEY_SIZE_IN_BYTES : UInt = 16

class encryptionTests: XCTestCase {
    
    func testExample() {
      var buf : [UInt8] = [UInt8](count: Int(KEY_SIZE_IN_BYTES), repeatedValue : 0)
      arc4random_buf(&buf, KEY_SIZE_IN_BYTES)
      println(buf)
      XCTAssertEqual(Int(KEY_SIZE_IN_BYTES), buf.count)
    }
  
  func testBase64() {
    let str = "iOS Developer Tips encoded in Base64"
    println("Original: \(str)")
    
    // UTF 8 str from original
    // NSData! type returned (optional)
    let utf8str = str.dataUsingEncoding(NSUTF8StringEncoding)
    
    // Base64 encode UTF 8 string
    // fromRaw(0) is equivalent to objc 'base64EncodedStringWithOptions:0'
    // Notice the unwrapping given the NSData! optional
    // NSString! returned (optional)
    let base64Encoded = utf8str!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
    println("Encoded:  \(base64Encoded)")
    
    // Base64 Decode (go back the other way)
    // Notice the unwrapping given the NSString! optional
    // NSData returned
    let data = NSData(base64EncodedString: base64Encoded, options: NSDataBase64DecodingOptions.fromRaw(0)!)
    
    // Convert back to a string
    let base64Decoded = NSString(data: data, encoding: NSUTF8StringEncoding)
    println("Decoded:  \(base64Decoded)")
    XCTAssertEqual(str, base64Decoded as String)
  }
  
  func testEncodingDecodingWithAPassword() {
    let content = "To be or not to be"
    let data = content.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    let enc = CypherHelper.encryptData(data, password: "herty")
    let decr = CypherHelper.decryptData(enc, password: "herty")
    XCTAssertEqual(content, NSString(data: decr, encoding: NSUTF8StringEncoding) as String)
  }
}
