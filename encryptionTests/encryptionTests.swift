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

let KEY_SIZE_IN_BYTES : UInt = 16

class encryptionTests: XCTestCase {
    
    func testExample() {
      var buf : [Byte] = [Byte](count: Int(KEY_SIZE_IN_BYTES), repeatedValue : 0)
      arc4random_buf(&buf, KEY_SIZE_IN_BYTES)
      println(buf)
      XCTAssertEqual(Int(KEY_SIZE_IN_BYTES), buf.count)
      var text = "Mama mula mimi"
      var result : [Byte]
    }
}
