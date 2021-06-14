//
//  UserDefaults + Extensions.swift
//  TwistGroup
//
//  Created by Aritro Paul on 6/12/21.
//

import Foundation

var playData : [String: Int] = [:]
var timeData : [String: [String: Double]] = [:]

class Defaults {
    static let shared = Defaults()
    static let userDefaults = UserDefaults.standard
    
    func save() {
        Defaults.userDefaults.set(playData, forKey: "playData")
        Defaults.userDefaults.set(timeData, forKey: "timeData")
    }
    
    func load() {
        playData = Defaults.userDefaults.object(forKey: "playData") as? [String:Int] ?? [:]
        timeData = Defaults.userDefaults.object(forKey: "timeData") as? [String:[String:Double]] ?? [:]
    }
    
    
}
