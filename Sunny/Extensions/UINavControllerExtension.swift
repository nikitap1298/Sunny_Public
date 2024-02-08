//
//  UINavControllerExtension.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 25.07.2022.
//

import UIKit

// Different transition styles for Navigation Controller
extension UINavigationController {
    
    // Type 1
    func pushViewControllerFromLeftType1(controller: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        pushViewController(controller, animated: false)
    }
    
    func popViewControllerToLeftType1() {
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        popViewController(animated: false)
    }
    
    func pushViewControllerFromRightType1(controller: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        pushViewController(controller, animated: false)
    }
    
    func popViewControllerToRightType1() {
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        popViewController(animated: false)
    }
    
    func popToRootViewControllerToBottom() {
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        popToRootViewController(animated: false)
    }
    
    // Type 2
    func pushViewControllerFromLeftType2(controller: UIViewController) {
        UIView.transition(with: view, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            self.pushViewController(controller, animated: false)
        }, completion: nil)
    }
    
    func popViewControllerToLeftType2() {
        UIView.transition(with: view, duration: 0.5, options: .transitionFlipFromRight, animations: {
            self.popViewController(animated: false)
        }, completion: nil)
    }
    
    func pushViewControllerFromRightType2(controller: UIViewController) {
        UIView.transition(with: view, duration: 0.5, options: .transitionFlipFromRight, animations: {
            self.pushViewController(controller, animated: false)
        }, completion: nil)
    }
    
    func popViewControllerToRightType2() {
        UIView.transition(with: view, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            self.popViewController(animated: false)
        }, completion: nil)
    }
}
