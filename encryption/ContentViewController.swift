import UIKit
import MessageUI

class ContentViewController: UICollectionViewController, MFMailComposeViewControllerDelegate, EntryDelegate
{
    var username : String!
    var content = [String]()
    lazy var filePath : String = {
        [unowned self] in
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var userPath = path.stringByAppendingPathComponent(self.username)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: self)
        if segue.identifier == "addEntry" {
            var vc = (segue.destinationViewController as UINavigationController).topViewController as AddEntryViewController
            println("View Controller:\(vc)")
            vc.delegate = self
        }
    }
    
    func encryptTextToFile(text: String, fileName: String) {
        let data = NSData(bytes: [UInt8](text.utf8), length: countElements(text.utf8))
        var encrypted = CypherHelper.encryptData(data, password: SSKeychain.passwordForService(ServiceName, account: username))
        let base64edEncrypted = encrypted.base64EncodedDataWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        base64edEncrypted.writeToFile(fileName, atomically: true)
    }
    
    func decryptTextFromFile(fileName : String) -> String {
        if let contents = NSFileManager.defaultManager().contentsAtPath(fileName) {
            if let plainReadData = NSData(base64EncodedData: contents, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters) {
                if let decryptedData = CypherHelper.decryptData(plainReadData, password: SSKeychain.passwordForService(ServiceName, account: username)) {
                    return NSString(data: decryptedData, encoding: NSUTF8StringEncoding) as String
                }
            }
        }
        return ""
    }
    
    func onEntryAdded(newEntry: String) {
        if newEntry.isEmpty {
            UIAlertView(title: "Error", message: "Added text should not be empty", delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        encryptTextToFile(newEntry, fileName: filePath.stringByAppendingPathComponent("enc-\(self.content.count).securedData"))
        self.content.append(newEntry)
        collectionView.reloadData()
    }
    
    func onEntryAdditionCancelled() {
        /// do nothing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        var fileManager = NSFileManager.defaultManager()
        var error : NSError?
        var contents = fileManager.contentsOfDirectoryAtPath(filePath, error: &error) as [String]
        for f in contents {
            if f.hasSuffix(".securedData") {
                let t = decryptTextFromFile(filePath.stringByAppendingPathComponent(f))
                if !t.isEmpty {
                    self.content.append(t)
                }
            } else {
                println("File is not secured")
            }
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photo_cell", forIndexPath: indexPath) as ContentVIewCell
        cell.textLabel.text = content[indexPath.row]
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let text = content[indexPath.row]
        var mailController = MFMailComposeViewController()
        mailController.mailComposeDelegate = self
        mailController.setSubject("Configuration Matrix Air")
        mailController.setMessageBody("Use this configuration file to initialize an app", isHTML: false)
        mailController.setToRecipients([])
        mailController.addAttachmentData(createConfigData(), mimeType: "application/airconfig", fileName: "config.qwe")
        presentViewController(mailController, animated: true, completion: nil)
    }
    
    func createConfigData() -> NSData {
        let result = content.reduce("", combine: { (res : String, el: String) -> String in
            if res.isEmpty {
                return res + el
            } else {
                return res + ";" + el
            }
        })
        return NSData(bytes: [UInt8](result.utf8), length: countElements(result.utf8))
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
