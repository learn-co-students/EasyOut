//
//  FirebaseFinal.swift
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 4/6/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

import Foundation
import Firebase


@objc class FireBaseAPIClient: NSObject {
    
    var firebaseURL: NSURL = NSURL.fileURLWithPath("")
    
    class func getAllUsersWithCompletion(completion:(success: Bool) -> ()) {
        
        //hit firebase reference (using firebaseURL)
        //Use the method firebase provides to do this (get that snapshot stuff)
        //when you have snapshot stuff, loop through it or whatever to create your custom objects.
        //then call on completion
        
        completion(success: true)
        
    }
    
    func sayHi() {
        print("Hi everyone.")
    }
}