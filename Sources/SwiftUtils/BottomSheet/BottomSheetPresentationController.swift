//
//  BottomSheetPresentationController.swift
//
//
//  Created by Marcio F. Paludo on 29/01/21.
//

import UIKit

final class BottomSheetPresentationController: UIPresentationController {
    
    private lazy var dimmingView: UIView = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismiss)), view = UIView()
        view.backgroundColor = .init(white: 0, alpha: 0.4)
        view.addGestureRecognizer(gesture)
        return view
    }()
    private lazy var panGesture: UIPanGestureRecognizer = {
        UIPanGestureRecognizer(target: self, action: #selector(drag(_:)))
    }()
    private var presentedViewCenter: CGPoint = .zero
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        switch sheetSizingStyle {
            case .adaptive: return adaptiveFrame
            case .toSafeAreaTop: return toSafeAreaTopFrame
            case .fixed(let height): return fixedFrame(height)
        }
    }
    
    private var adaptiveFrame: CGRect {
        guard let containerView = containerView, let presentedView = presentedView else { return .zero }
        let frame = containerView.bounds.inset(by: containerView.safeAreaInsets)
        
        // Fitting size for auto layout
        let fittingSize = CGSize(width: frame.width, height: UIView.layoutFittingCompressedSize.height)
        var targetHeight = presentedView.systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow).height
        
        // Handle cases when the containerView does not use auto layout
        if let tableView = presentedView.subviews.first(where: { $0 is UITableView }) as? UITableView {
            targetHeight += tableView.contentSize.height
        }
        if let tableView = presentedView as? UITableView {
            targetHeight += tableView.contentSize.height
        }
        if let collectionView = presentedView.subviews.first(where: { $0 is UICollectionView }) as? UICollectionView {
            targetHeight += collectionView.contentSize.height
        }
        if let collectionView = presentedView as? UICollectionView {
            targetHeight += collectionView.contentSize.height
        }
        
        // Add the bottom safe area inset
        targetHeight += containerView.safeAreaInsets.bottom
        
        return targetHeight > toSafeAreaTopFrame.height ? toSafeAreaTopFrame : .init(
            origin: .init(x: frame.origin.x, y: frame.origin.y + (frame.size.height - targetHeight)),
            size: .init(width: frame.width, height: targetHeight)
        )
    }
    
    private var toSafeAreaTopFrame: CGRect {
        guard let containerView = containerView else { return .zero }
        var frame = containerView.bounds.inset(by: containerView.safeAreaInsets)
        frame.origin.y += containerView.safeAreaInsets.bottom
        return frame
    }
    
    private func fixedFrame(_ height: CGFloat) -> CGRect {
        guard let containerView = containerView else { return .zero }
        return height > toSafeAreaTopFrame.height ? toSafeAreaTopFrame : {
            var frame = containerView.bounds.inset(by: containerView.safeAreaInsets)
            frame.origin.y += containerView.safeAreaInsets.bottom
            frame.size.height = height
            return frame
        }()
    }
    
    /// The style of the bottom sheet
    var sheetSizingStyle: BottomSheetView.SheetSizingStyle {
        guard let presentedController = presentedViewController as? BottomSheetController else { return .toSafeAreaTop }
        return presentedController.sheetSizingStyle
    }
    
    public init(presentedViewController: BottomSheetController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    public override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        guard let presentedView = presentedView else { return }
        
        if !(presentedView.gestureRecognizers?.contains(panGesture) ?? false) {
            presentedView.addGestureRecognizer(panGesture)
        }
    }
    
    public override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
        guard let presenterView = containerView else { return }
        guard let presentedView = presentedView else { return }
        
        presentedView.frame = frameOfPresentedViewInContainerView
        
        let gap = presenterView.bounds.height - frameOfPresentedViewInContainerView.height
        presentedView.center = CGPoint(x: presenterView.center.x, y: presenterView.center.y + gap / 2)
        presentedViewCenter = presentedView.center
        dimmingView.frame = presenterView.bounds
    }
    
    public override func presentationTransitionWillBegin() {
        dimmingView.alpha = 0
        
        guard let presenterView = containerView else { return }
        presenterView.addSubview(dimmingView)
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            self?.dimmingView.alpha = 1
        }, completion: nil)
    }
        
    public override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            self?.dimmingView.alpha = 0
        }, completion: { [weak self] context in
            self?.dimmingView.removeFromSuperview()
        })
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
            
    @objc private func dismiss() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc private func drag(_ gesture: UIPanGestureRecognizer) {
        guard let presentedView = presentedView, let presenterView = containerView else { return }
        
        switch gesture.state {
            case .changed:
                presentingViewController.view.bringSubviewToFront(presentedView)
                let translation = gesture.translation(in: presentingViewController.view)
                let y = presentedView.center.y + translation.y

                let gap = presenterView.bounds.height - presentedView.frame.height
                let shouldBounce = y - gap / 2 > presentingViewController.view.center.y

                if shouldBounce {
                    presentedView.center = CGPoint(x: presentedView.center.x, y: y)
                }

                gesture.setTranslation(.zero, in: presentingViewController.view)
            case .ended:
                let height = presentingViewController.view.frame.height
                let position = presentedView.convert(presentingViewController.view.frame, to: nil).origin.y

                let velocity = gesture.velocity(in: presentedView)
                let targetVelocityHeight = presentedView.frame.height * 2
                let targetDragHeight = presentedView.frame.height * 3 / 4

                if velocity.y > targetVelocityHeight || height - position < targetDragHeight {
                    dismiss()
                } else {
                    restorePosition()
                    restoreDimming()
                }

                gesture.setTranslation(.zero, in: presentingViewController.view)
            default: break
        }
    }
    
    private func restorePosition() {
        guard let presentedView = presentedView else { return }
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            presentedView.center = self.presentedViewCenter
        }
    }
    
    private func restoreDimming() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.dimmingView.alpha = 1.0
        }
    }
    
}
