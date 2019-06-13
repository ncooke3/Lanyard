//  Created by Jonathan Valldejuli on 9/16/17.

import UIKit

struct UIKeyboardNotificationData {
    
    let animationCurve: UIView.AnimationCurve
    let animationDuration: Double
    let keyboardPresentedByThisApp: Bool
    let keyboardStartFrame: CGRect
    let keyboardEndFrame: CGRect
    
    init?(keyboardNotification: Notification) {
        
        guard let userInfo = keyboardNotification.userInfo,
            let animationCurveRawValue = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue,
            let animationCurve = UIView.AnimationCurve(rawValue: animationCurveRawValue),
            let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
            let keyboardPresentedByThisApp = (userInfo[UIResponder.keyboardIsLocalUserInfoKey] as? NSNumber)?.boolValue,
            let keyboardStartFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return nil }
        
        self.animationCurve = animationCurve
        self.animationDuration = animationDuration
        self.keyboardPresentedByThisApp = keyboardPresentedByThisApp
        self.keyboardStartFrame = keyboardStartFrame
        self.keyboardEndFrame = keyboardEndFrame
        
    }
    
    static func handleKeyboardWillShow(notification: Notification, forScrollView scrollView: UIScrollView, animated: Bool) {
        
        guard let keyboardNotificationData = UIKeyboardNotificationData(keyboardNotification: notification)
        else { return }
        
        let insetChanges = {
            let contentInsetBottom = keyboardNotificationData.keyboardEndFrame.height - scrollView.safeAreaInsets.bottom
            scrollView.contentInset.bottom = contentInsetBottom + 10
            scrollView.scrollIndicatorInsets.bottom = contentInsetBottom
        }
        
        if animated {
            UIView.animate(withDuration: keyboardNotificationData.animationDuration, delay: 0, options: keyboardNotificationData.animationCurve.asAnimationOptions, animations: insetChanges)
        }
        else {
            insetChanges()
        }
        
    }
    
    static func handleKeyboardWillHide(notification: Notification, forScrollView scrollView: UIScrollView, animated: Bool) {
        
        guard let keyboardNotificationData = UIKeyboardNotificationData(keyboardNotification: notification)
        else { return }
        
        let insetChanges = {
            let contentInsetBottom: CGFloat = 20.0
            scrollView.contentInset.bottom = contentInsetBottom
            scrollView.scrollIndicatorInsets.bottom = contentInsetBottom
        }
        
        if animated {
            UIView.animate(withDuration: keyboardNotificationData.animationDuration, delay: 0, options: keyboardNotificationData.animationCurve.asAnimationOptions, animations: insetChanges)
        }
        else {
            insetChanges()
        }
        
    }
    
}

extension UIView.AnimationCurve {
    var asAnimationOptions: UIView.AnimationOptions {
        switch self {
        case .easeInOut:
            return .curveEaseInOut
        case .easeIn:
            return .curveEaseIn
        case .easeOut:
            return .curveEaseOut
        case .linear:
            return .curveLinear
        default:
            return .curveLinear
        }
    }
}
