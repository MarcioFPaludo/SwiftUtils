//
//  DateFormatterExtensions.swift
//  
//
//  Created by Marcio F. Paludo on 26/01/21.
//

import Foundation

// MARK: - Date

extension Date {
    fileprivate static let dateFormatter = DateFormatter()
    
    /**
     Generates an `String` from the ` Date` with the date format specified.
     
     - parameter format: The date format used to generate the date `String`.
     
     - returns An `String` generated with the specified date format
    */
    public func string(withFormat format: String) -> String {
        let formmater = Self.dateFormatter
        formmater.dateFormat = format
        return formmater.string(from: self)
    }
}

// MARK: - String

extension String {
    fileprivate static let dateFormatter = DateFormatter()
    
    /**
     Attempts to generate  an `Date` from the `String` with the date format specified.
     
     - parameter format: The date format used to generate the `Date`.
     
     - returns An `Date` generated with the specified date format or `nil` if cant generate an date with the `String`
    */
    public func date(withFormat format: String) -> Date? {
        let formmater = Self.dateFormatter
        formmater.dateFormat = format
        return formmater.date(from: self)
    }
}

// MARK: - UserDefaults

extension UserDefaults {
    private static let dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSSZ"
    
    /// -dateForKey: is equivalent to -objectForKey:, except that it will return nil if the value is not an NSDate.
    public func date(forKey defaultName: String) -> Date? {
        return string(forKey: defaultName)?.date(withFormat: Self.dateFormat)
    }
    
    /// -setDate:forKey: is equivalent to -setObject:forKey: except that the value is converted from an NSDate to an String.
    public func set(_ value: Date?, forKey defaultName: String) {
        return set(value?.string(withFormat: Self.dateFormat), forKey: defaultName)
    }
}
