//
//  DispatchQueue.swift
//  DispatchQueue
//
//  Created by Abdulmunaf Chhatra on 4/3/15.
//  Copyright (c) 2015 Abdulmunaf Chhatra. All rights reserved.
//

import Foundation

public class DispatchQueue {
    
    public let label: String
    
    let queue: dispatch_queue_t
    
    public init(queue: dispatch_queue_t) {
        self.queue = queue
        self.label = String.fromCString(dispatch_queue_get_label(queue))!
    }
    
    public func dispatchAsync(block: dispatch_block_t) -> Self {
        dispatch_async(queue, block)
        return self
    }
    
    public func dispatchSync(block: dispatch_block_t) -> Self {
        dispatch_sync(queue, block)
        return self
    }
    
    public func dispatchAfterSeconds(seconds: UInt, block: dispatch_block_t) -> Self {
        dispatch_after(SecondsFromNow(seconds), queue, block)
        return self
    }
    
    public func suspend() {
        dispatch_suspend(queue)
    }
    
    public func resume() {
        dispatch_resume(queue)
    }
}