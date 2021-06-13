//
//  UserDefaults + Extensions.swift
//  TwistGroup
//
//  Created by Aritro Paul on 6/12/21.
//

import Foundation

var playData : [String: Int] = [:]

class Defaults {
    static let shared = Defaults()
    static let userDefaults = UserDefaults.standard
    
    func save() {
        Defaults.userDefaults.set(playData, forKey: "playData")
    }
    
    func load() {
        playData = Defaults.userDefaults.object(forKey: "playData") as? [String:Int] ?? [:]
    }
}
