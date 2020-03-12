//
//  ViewTransitionsHelper.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-02-19.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import UIKit
import SafariServices

class HelperViewTransitions{
    
    static func showMainViewController(_ shouldShowAppointmentsController:Bool, _ viewController:UIViewController){
        let tabBarController = TabBarController()
        tabBarController.shouldShowAppointmentsController = shouldShowAppointmentsController
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window!.rootViewController = tabBarController

        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.3
        UIView.transition(with: appdelegate.window!, duration: duration, options: options, animations: {}, completion:
        { completed in
        })
    }
    
    
    static func showUsersNameController(_ navigationController:UINavigationController?){
        let viewController = UsersNameController()
        let NC = UINavigationController(rootViewController: viewController)
        NC.modalPresentationStyle = .overFullScreen
        NC.modalTransitionStyle = .crossDissolve
        navigationController?.present(NC, animated: true, completion: nil)
    }
    
    static func showLearnMoreViewController(viewCode:Int, currentViewController:UIViewController){
        let viewController = LearnMoreViewController()
        viewController.VIEW_CODE = viewCode
        currentViewController.present(viewController, animated: true, completion: nil)
    }
    
    static func showAvailabilityControllerScheduler(currentViewController:UIViewController){
        let viewController = AvailabilityController()
        let navigationController = UINavigationController(rootViewController: viewController)
        currentViewController.present(navigationController, animated:true)
    }
    
    static func showWebPageURL(urlString:String, viewController:UIViewController){
        let url = URL(string: urlString)
        let svc = SFSafariViewController(url: url!)
        viewController.present(svc, animated: true, completion: nil)
    }
    
    
    
}
