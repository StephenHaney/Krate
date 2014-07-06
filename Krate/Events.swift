//
//  Events.swift
//  Krate
//
//  Created by Stephen Haney on 7/5/14.
//  Copyright (c) 2014 Stephen Haney. All rights reserved.
//

import Foundation

class GameEvents {
    var listeners:String[] = [];
    
    func trigger(eventName:String) {
        if (listeners.filter { $0 == eventName }) {
            println("ya we're here");
        }
    }
}