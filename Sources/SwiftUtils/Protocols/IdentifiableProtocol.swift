//
//  IdentifiableProtocol.swift
//  
//
//  Created by Marcio F. Paludo on 26/01/21.
//

import UIKit

public protocol IdentifiableProtocol {
    /// An `String` value to identifie the class
    static var identifier: String { get }
}
