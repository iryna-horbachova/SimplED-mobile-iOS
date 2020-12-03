import Foundation
import UIKit

class Utilities {
  
  static func loadImage(imageView: UIImageView, baseURLString: String) {
    let urlString = APIManager.shared.baseImageURL + baseURLString
    if let url = URL(string: urlString) {
      DispatchQueue.global(qos: .userInitiated).async {
        let urlContents = try? Data(contentsOf: url)
        DispatchQueue.main.async {
          if let imageData = urlContents {
            imageView.image = UIImage(data: imageData)
          }
        }
      }
    }
  }
}

public enum ImageOption: String {
  case profilePic = "profile_pics"
  case coursePic = "course_pics"
}

public struct Participant: Codable {
  public let id: Int
  public let fullName: String
}
