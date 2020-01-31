//
//  UserdefaultsService.swift
//  FarmaTest
//
//  Created by Bartosz Pawełczyk on 30/01/2020.
//  Copyright © 2020 Bartosz Pawełczyk. All rights reserved.
//

import Foundation

class DefaultsKeys {}

class DefaultsKey<T>: DefaultsKeys {
    let name: String
    
    init(_ name: String) {
        self.name = name
    }
}

extension UserDefaults {
    func get<T>(_ key: DefaultsKey<T>) -> T? {
        return object(forKey: key.name) as? T
    }
    
    func set<T>(_ key: DefaultsKey<T>, to value: T) {
        set(value, forKey: key.name)
    }
}

//MARK: - Defined keys

extension DefaultsKeys {
    static let lastSynchronizationTimestamp = DefaultsKey<String>("lastSynchronizationTimestamp")
}
