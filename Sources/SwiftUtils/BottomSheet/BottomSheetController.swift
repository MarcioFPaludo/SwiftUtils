//
//  BottomSheetController.swift
//
//
//  Created by Marcio F. Paludo on 29/01/21.
//

import UIKit

public class BottomSheetController: UIViewController {
    
    private let bottomSheetView = BottomSheetView()
    
    public var sheetSizingStyle: BottomSheetView.SheetSizingStyle {
        get { bottomSheetView.sheetSizingStyle }
        set { bottomSheetView.sheetSizingStyle = newValue }
    }
    
    public weak var contentVC: UIViewController? {
        willSet {
            contentVC?.removeFromParent()
            
            if let vc = newValue {
                addChild(vc)
                if contentView != vc.view {
                    contentView = vc.view
                }
            }
        }
    }
    
    public var contentView: UIView {
        get { bottomSheetView.contentView }
        set { bottomSheetView.contentView = newValue }
    }
    
    public var contentInsets: UIEdgeInsets {
        get { bottomSheetView.contentInsets }
        set { bottomSheetView.contentInsets = newValue }
    }
    
    public convenience init(withContent vc: UIViewController) {
        self.init(withContent: vc.view)
        contentVC = vc
        addChild(vc)
    }
    
    public required init(withContent view: UIView) {
        super.init(nibName: nil, bundle: nil)
        contentView = view
        commonInit()
    }
    
    internal override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }
    
    internal required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        modalPresentationStyle = .custom
        transitioningDelegate = BottomSheetTransitioningDelegate.default
    }
    
    public override func loadView() {
        super.loadView()
        view = bottomSheetView
        bottomSheetView.accessibilityIdentifier = "Bottom Sheet"
    }
}

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
struct BottomSheetControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = BottomSheetController
    
    func makeUIViewController(context: Context) -> BottomSheetController {
        let controller = BottomSheetController()
        controller.contentView.backgroundColor = .systemPink
        return controller
    }
    
    func updateUIViewController(_ uiViewController: BottomSheetController, context: Context) {
        
    }
}

@available(iOS 13, *)
struct BottomSheetControllerPreview: PreviewProvider {
    static var previews: some View {
        BottomSheetControllerRepresentable()
    }
}
#endif
