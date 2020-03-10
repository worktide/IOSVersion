//
//  HelperLoading.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-02-21.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import Foundation
import UIKit

class HelperLoading {
    
    static func showLoading(message:String, viewController: UIViewController){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating()
            
        alert.view.addSubview(loadingIndicator)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showUploadingFail(viewController:UIViewController){
        let alert = UIAlertController(title: nil, message: "Failed to save", preferredStyle: .alert)
        viewController.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: {viewController.dismiss(animated: true, completion: nil)})
        }
    }
    
    static func showUploadingSuccessful(viewController:UIViewController){
        let alert = UIAlertController(title: nil, message: "Saved", preferredStyle: .alert)
        viewController.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: {viewController.dismiss(animated: true, completion: nil)})
        }
    }
    
}
