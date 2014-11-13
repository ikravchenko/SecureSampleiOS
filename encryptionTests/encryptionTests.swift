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
    
    func testGenerateAES128Key() {
        var buf : [UInt8] = [UInt8](count: Int(KEY_SIZE_IN_BYTES), repeatedValue : 0)
        arc4random_buf(&buf, KEY_SIZE_IN_BYTES)
        println(buf)
        XCTAssertEqual(Int(KEY_SIZE_IN_BYTES), buf.count)
    }
    
    func testBase64Encoding() {
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
        let data = NSData(base64EncodedString: base64Encoded, options: NSDataBase64DecodingOptions(rawValue: 0))
        
        // Convert back to a string
        let base64Decoded = NSString(data: data!, encoding: NSUTF8StringEncoding)
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
    
    //    func testSharedFiles() {
    //        let fm = NSFileManager.defaultManager()
    //        var dir = fm.containerURLForSecurityApplicationGroupIdentifier("group.encryption")
    //        if let d = dir {
    //            var file = dir?.URLByAppendingPathComponent("file.bsp")
    //            if let f = file {
    //                var handle = NSFileHandle(forReadingFromURL: f, error: nil)
    //                var fileContents = handle?.readDataToEndOfFile()
    //                XCTAssertNotNil(fileContents, "file is not empty")
    //                let str = NSString(data: fileContents!, encoding: NSUTF8StringEncoding)
    //                println("contents:\(str)")
    //            }
    //        }
    ////        let files = fm.contentsOfDirectoryAtURL(dir!, includingPropertiesForKeys: nil, options: nil, error: nil)
    ////        XCTAssertNotNil(files, "file are empty")
    //////        println("Files:\(files)")
    ////        for f in files as [String] {
    ////            println("Name:\(f)")
    ////
    ////        }
    //    }
    
    lazy var filePath : String = {
        [unowned self] in
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var userPath = path.stringByAppendingPathComponent("main")
        var fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(userPath) {
            println("Directory exists")
        } else {
            var error : NSError?
            fileManager.createDirectoryAtPath(userPath, withIntermediateDirectories: true, attributes: nil, error: &error)
            if let err = error {
                println("Cannot create a directory")
            }
        }
        return userPath
        }()
    
    let FileName = "enc.securedData"
    
    func testShouldEncodeDecodeData() {
        let content = "sample"
        SSKeychain.setPassword("qwerty", forService: ServiceName, account: "main")
        let data = NSData(bytes: [UInt8](content.utf8), length: countElements(content.utf8))
        var encrypted = CypherHelper.encryptData(data, password: SSKeychain.passwordForService(ServiceName, account: "main"))
        XCTAssertNotNil(encrypted)
        println(encrypted)
        let base64edencrypted = encrypted.base64EncodedDataWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        base64edencrypted.writeToFile(filePath.stringByAppendingPathComponent(FileName), atomically: true)
        var contents = NSFileManager.defaultManager().contentsAtPath(filePath.stringByAppendingPathComponent(FileName))
        XCTAssertEqual(base64edencrypted, contents!)
        var plainReadData = NSData(base64EncodedData: contents!, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        var decryptedData = CypherHelper.decryptData(plainReadData, password: SSKeychain.passwordForService(ServiceName, account: "main")) as NSData
        XCTAssertNotNil(decryptedData)
        let result = NSString(data: decryptedData, encoding: NSUTF8StringEncoding) as String
        XCTAssertEqual(content, result)
    }
    
    func testSHA512() {
        var sha512 = CypherHelper.createSHA512("content")
        XCTAssertNotNil(sha512)
        println(sha512)
    }
    
    func testSHA512_32() {
        var sha512 = CypherHelper.createSHA512("content")
        for _ in 0...31 {
            sha512 = CypherHelper.createSHA512(sha512)
        }
        XCTAssertNotNil(sha512)
        println(sha512)
    }
    
    func testSHA512_256() {
        var sha512 = CypherHelper.createSHA512("content")
        for _ in 0...255 {
            sha512 = CypherHelper.createSHA512(sha512)
        }
        XCTAssertNotNil(sha512)
        println(sha512)
    }
    
    override func tearDown() {
        super.tearDown()
        SSKeychain.deletePasswordForService(ServiceName, account: "main")
    }
}
