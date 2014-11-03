import UIKit
import MobileCoreServices
import MessageUI

class PhotosViewController: UICollectionViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
  var username : String!
  var photos : [UIImage] = [UIImage]()
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
  
  @IBAction func takePhoto(sender: UIBarButtonItem) {
    UIActionSheet(title: "Select source", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Camera", "Photo Library").showFromBarButtonItem(sender, animated: true)
  }
  
  func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
    var ip = UIImagePickerController()
    ip.allowsEditing = true
    ip.delegate = self
    
    if buttonIndex == 1 {
      ip.sourceType = .Camera
    } else if buttonIndex == 2 {
      ip.sourceType = .PhotoLibrary
    }
    presentViewController(ip, animated: true, completion: nil)
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    var image: UIImage = info[UIImagePickerControllerEditedImage] as? UIImage ?? info[UIImagePickerControllerOriginalImage] as UIImage
    var data =  UIImagePNGRepresentation(image)
    var name : String = "image-\(photos.count + 1).securedData"
    var encrypted = CypherHelper.encryptData(data, password: SSKeychain.passwordForService(ServiceName, account: username))
    encrypted.writeToFile(filePath.stringByAppendingPathComponent(name), atomically: true)
    photos.append(image)
    collectionView.reloadData()
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadPhotos()
  }
  
  func loadPhotos() {
    var fileManager = NSFileManager.defaultManager()
    var error : NSError?
    var contents = fileManager.contentsOfDirectoryAtPath(filePath, error: &error) as [String]
    for f in contents {
      if f.hasSuffix(".securedData") {
        var data = NSData(contentsOfFile: filePath.stringByAppendingPathComponent(f), options: .DataReadingMappedIfSafe, error: nil)
        var decryptedData = CypherHelper.decryptData(data, password: SSKeychain.passwordForService(ServiceName, account: username))
        self.photos.append(UIImage(data: decryptedData)!)
      } else {
        println("File is not secured")
      }
    }
  }
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return photos.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photo_cell", forIndexPath: indexPath) as PhotoViewCell
    cell.imageView.image = photos[indexPath.row]
    return cell
  }
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let photo = photos[indexPath.row]
    var mailController = MFMailComposeViewController()
    mailController.mailComposeDelegate = self
    mailController.setSubject("Photo")
    mailController.setMessageBody("Please find a photo attached", isHTML: false)
    mailController.setToRecipients(["ivan.kravchenko@dorma.com"])
    mailController.addAttachmentData(UIImagePNGRepresentation(photo), mimeType: "image/png", fileName: filePath.stringByAppendingPathComponent("image-\(indexPath.row).securedData"))
    presentViewController(mailController, animated: true, completion: nil)
  }
  
  func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}
