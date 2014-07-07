//
//  Events.swift
//  Krate
//
//  Created by Stephen Haney on 7/5/14.
//  Copyright (c) 2014 Stephen Haney. All rights reserved.
//

import Foundation

class EventManager {
    var listeners = Dictionary<String, NSMutableArray>();

    init() {
    }
    
    func listenTo(eventName:String, action:(()->())) {
        let newListenerAction = EventListenerAction(action);
        
        self.listeners[eventName] = [newListenerAction] as NSMutableArray;
        
        //self.listeners[eventName]!.addObject(callback);
    }
    
    func trigger(eventName:String, information:AnyObject = []) {
        let actionList = self.listeners[eventName];
        
        if (actionList) {
            for action in actionList! {
                let actionToPerform = action as EventListenerAction;
                actionToPerform.action();
            }
        }
    }
}

class EventListenerAction {
    let action:(() -> ());
    
    init(callback:(() -> ())) {
        self.action = callback;
    }
}