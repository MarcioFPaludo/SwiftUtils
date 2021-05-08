//
//  UIView+Utils.swift
//  
//
//  Created by Marcio F. Paludo on 03/02/21.
//

import UIKit

extension UIView {
    public enum Edge { case edges, layoutMargin, safeArea }
    
    /**
     Extend the current View to the Edges of the received View (or view `LayoutGuide`).
     
     - parameter edge: Value of `Edge` enum that define the achors used to create the view edges constraints.
     - parameter view: The view where the current view will be added to the edges.
     - parameter insets: The value of the constant that will be used to add space from the edges.
     */
    public func pinTo(_ edge: Edge, of view: UIView, with insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints: [NSLayoutConstraint] = []
        view.addSubview(self)
        
        switch edge {
        case .edges:
            constraints.append(topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top))
            constraints.append(leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left))
            constraints.append(bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom))
            constraints.append(trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right))
        default:
            let layoutGuide = edge == .layoutMargin ? view.layoutMarginsGuide : view.safeAreaLayoutGuide
            constraints.append(topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: insets.top))
            constraints.append(leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: insets.left))
            constraints.append(bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -insets.bottom))
            constraints.append(trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -insets.right))
        }
        
        view.addConstraints(constraints)
        NSLayoutConstraint.activate(constraints)
    }
}
