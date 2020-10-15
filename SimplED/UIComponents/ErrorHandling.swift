import UIKit
import Foundation

extension UIAlertController {
  static func errorAlertWithOKAction(message: String) -> UIAlertController {
    let title = NSLocalizedString(
      "ERROR_TITLE",
      value: "Error occured",
      comment: "Generic error title")
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default))
    return alertController
  }
}
