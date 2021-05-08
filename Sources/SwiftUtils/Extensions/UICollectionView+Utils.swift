//
//  UICollectionView+Utils.swift
//  
//
//  Created by Márcio Fochesato Paludo on 11/04/21.
//

import UIKit

extension UICollectionView {
    public func dequeueReusableCell<T: UICollectionViewCell & IdentifiableProtocol>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
    
    public func register<T: UICollectionViewCell & IdentifiableProtocol>(_ type: T.Type, hasNib: Bool = false) {
        if (hasNib) {
            let nib = UINib(nibName: String(describing: type), bundle: nil)
            register(nib, forCellWithReuseIdentifier: T.identifier)
        } else {
            register(type, forCellWithReuseIdentifier: T.identifier)
        }
    }
}
