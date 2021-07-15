//
//  UITableView+Utils.swift
//  
//
//  Created by Márcio Fochesato Paludo on 11/04/21.
//

import UIKit

extension UITableView {
    public func dequeueReusableCell<T: UITableViewCell & IdentifiableProtocol>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
    
    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView & IdentifiableProtocol>(with type: T.Type) -> T? {
        return dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as? T
    }
    
    public func registerCell<T: UITableViewCell & IdentifiableProtocol>(_ type: T.Type, hasNib: Bool = false) {
        if (hasNib) {
            let nib = UINib(nibName: String(describing: type), bundle: nil)
            register(nib, forCellReuseIdentifier: T.identifier)
        } else {
            register(type, forCellReuseIdentifier: T.identifier)
        }
    }
    
    public func registerHeaderFooterView<T: UITableViewHeaderFooterView & IdentifiableProtocol>(_ type: T.Type, hasNib: Bool = false) {
        if (hasNib) {
            let nib = UINib(nibName: String(describing: type), bundle: nil)
            register(nib, forHeaderFooterViewReuseIdentifier: T.identifier)
        } else {
            register(type, forHeaderFooterViewReuseIdentifier: T.identifier)
        }
    }
}
