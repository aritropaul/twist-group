//
//  WatchTogether.swift
//  TwistGroup
//
//  Created by Garima Bothra on 13/06/21.
//

import Foundation
import GroupActivities

 struct WatchTogether: GroupActivity {
     
     let source: URL
     static let activityIdentifier = "com.aritropaul.TwistGroup.WatchTogether"
     
     
     var metadata: GroupActivityMetadata {
         
         
         get {
         var metadata = GroupActivityMetadata()
         metadata.title = NSLocalizedString("Watch Together", comment: "Watch anime together and enjoy!")
             metadata.fallbackURL = source
         metadata.type = .generic
         return metadata
     }
     }
 }
