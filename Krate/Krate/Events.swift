//
//  Events.swift
//  Krate
//
//  Created by Stephen Haney on 7/5/14.
//  Copyright (c) 2014 Stephen Haney. All rights reserved.
//

import Foundation

class EventManager {
    // using NSMutableArray as Swift arrays can't change size inside dictionaries (yet, probably)
    var listeners = Dictionary<String, NSMutableArray>();
    
    // Create a new event listener
    // Parameters:
    // eventName: Matching trigger eventNames will cause this listener to fire
    // action: The block of code you want executed when the event triggers
    func listenTo(eventName:String, action:(()->())) {
        let newListenerAction = EventListenerAction(action);
        
        if let listenerArray = self.listeners[eventName] {
            // action array exists for this event, add new action to it
            listenerArray.addObject(newListenerAction);
        }
        else {
            // no listeners created for this event yet, create a new array
            self.listeners[eventName] = [newListenerAction] as NSMutableArray;
        }
    }
    
    // Removes all listeners by default, or specific listeners through paramters
    // Parameters:
    // eventName: If an event name is passed, only listeners for that event will be removed
    func removeListeners(eventNameToRemoveOrNil:String?) {
        if let eventNameToRemove = eventNameToRemoveOrNil {
            // remove listeners for a specific event
            
            if let actionArray = self.listeners[eventNameToRemove] {
                // actions for this event exist
                actionArray.removeAllObjects();
            }
        }
        else {
            // no specific parameters - remove all listeners on this object
            self.listeners.removeAll(keepCapacity: false);
        }
    }
    
    // Triggers an event
    // + eventName: Matching listener eventNames will fire when this is called
    // + information: pass values to your listeners
    func trigger(eventName:String, information:[AnyObject] = []) {
        if let actions = self.listeners[eventName] {
            for actionToPerform in actions {
                if actionToPerform is EventListenerAction {
                    (actionToPerform as EventListenerAction).action();
                }
            }
        }
    }
}

// Class to hold actions to live in NSMutableArray
class EventListenerAction {
    let action:(() -> ());
    
    init(callback:(() -> ())) {
        self.action = callback;
    }
}
