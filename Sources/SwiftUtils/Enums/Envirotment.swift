//
//  Envirotment.swift
//  
//
//  Created by Marcio F. Paludo on 28/01/21.
//

import Foundation

/// An enum with the basic project Envirotments
public enum Envirotment: String {
    case develop, homolog, production
    
    /**
     Store the current project envirotment using `Configuration` of the info dictionary
     For configure the project envirotments read the `EnvirotmentConfig` file.
     
     - returns an value that match with the configuration file or `production`.
     */
    public static let current: Self = {
        var env = Self.production
        
        if let configuration = (Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String)?.lowercased() {
            if ["develop", "dev", "development"].first(where: { return configuration.contains($0) }) != nil {
                env = .develop
            } else if ["homolog", "hml", "homologation"].first(where: { return configuration.contains($0) }) != nil {
                env = .homolog
            }
        }
        
        return env
    }()
}
