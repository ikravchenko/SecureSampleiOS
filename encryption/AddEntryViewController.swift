import UIKit

public class AddEntryViewController: UIViewController {
    weak var delegate : EntryDelegate?
    
    @IBOutlet var textField : UITextField!
    
    @IBAction func entryAdded(AnyObject) {
        if let d = delegate {
            d.onEntryAdded(textField.text)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func entryAdditionCancelled(AnyObject) {
        if let d = delegate {
            d.onEntryAdditionCancelled()
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}