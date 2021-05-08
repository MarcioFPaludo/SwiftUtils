//
//  BottomSheetTransitioningDelegate.swift
//
//
//  Created by Marcio F. Paludo on 29/01/21.
//

import UIKit

final class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    static let `default` = BottomSheetTransitioningDelegate()
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        guard let presentedController = presented as? BottomSheetController else { return nil }
        return BottomSheetPresentationController(presentedViewController: presentedController, presenting: presenting)
    }
}
