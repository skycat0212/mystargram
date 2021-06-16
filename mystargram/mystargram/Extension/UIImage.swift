//
//  UIImage.swift
//  mystargram
//
//  Created by Kim on 2021/06/16.
//

import Foundation
import UIKit

extension UIImage {
    
    func convertToBase64() -> String {
        return self.jpegData(compressionQuality: 0.02)?.base64EncodedString() ?? ""
    }
    
}
