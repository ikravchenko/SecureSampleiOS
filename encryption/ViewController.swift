import UIKit

let ServiceName = "MyService"

class ViewController: UIViewController, UIAlertViewDelegate {
  
  @IBOutlet var usernameField : UITextField!
  @IBOutlet var passwordField : UITextField!
  
  @IBAction func login(AnyObject) {
    if usernameField.text.isEmpty || passwordField.text.isEmpty {
      UIAlertView(title: "Error", message: "Username or password is epmty", delegate: nil, cancelButtonTitle: "Ok").show()
      return
    }

    if let password = SSKeychain.passwordForService(ServiceName, account: usernameField.text) {
      if password == passwordField.text {
        performSegueWithIdentifier("showPhotos", sender: self)
      } else {
        UIAlertView(title: "Error", message: "Password or username is incorrect",  delegate: nil, cancelButtonTitle: "Ok").show()
      }
    } else {
      UIAlertView(title: "Add account", message: "Do you want to register?", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Yes").show()
    }
  }
  
  func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
    if buttonIndex == 1 {
      var result = SSKeychain.setPassword(passwordField.text, forService: ServiceName, account: self.usernameField.text)
      if result {
        performSegueWithIdentifier("showPhotos", sender: self)
      }
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    super.prepareForSegue(segue, sender: sender)
    (segue.destinationViewController as PhotosViewController).username = self.usernameField.text
    self.passwordField.text = nil
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    (UIApplication.sharedApplication().delegate as AppDelegate).navigationController = navigationController
    var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    let files = NSFileManager.defaultManager().contentsOfDirectoryAtPath(path, error: nil)
    
    println("Files:\(files)")
  }
}

