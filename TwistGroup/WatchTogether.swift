//
//  WatchTogether.swift
//  TwistGroup
//
//  Created by Garima Bothra on 13/06/21.
//

import Foundation
import GroupActivities

 struct WatchTogether: GroupActivity {
     var metadata: GroupActivityMetadata {
         var metadata = GroupActivityMetadata()
         metadata.title = NSLocalizedString("Watch Together", comment: "Watch anime together and enjoy!")
         metadata.type = .generic
         return metadata
     }

 }
