//
//  DispatchGroup.swift
//  DispatchQueue
//
//  Created by Abdulmunaf Chhatra on 4/3/15.
//  Copyright (c) 2015 Abdulmunaf Chhatra. All rights reserved.
//

import Foundation

public class DispatchGroup {
    
    let group: dispatch_group_t
    
    let asyncQueue: DispatchQueue?
    
    public init() {
        group = dispatch_group_create()
    }
    
    public init(asyncQueue: DispatchQueue) {
        group = dispatch_group_create()
        self.asyncQueue = asyncQueue
    }
    
    public func enter() {
        dispatch_group_enter(group)
    }
    
    public func leave() {
        dispatch_group_leave(group)
    }

    public func dispatchSync(block: dispatch_block_t) {
        enter()
        block()
        leave()
    }
    
    public func dispatchAsync(block: dispatch_block_t) {
        if let queue = asyncQueue {
            dispatch_group_async(group, queue.queue, block)
        } else {
            assertionFailure("No async queue is set for this group")
        }
    }
    
    public func dispatchAsyncOnQueue(queue: DispatchQueue, block: dispatch_block_t) {
        dispatch_group_async(group, queue.queue, block)
    }
    
    public func waitForSeconds(seconds: UInt) -> Bool {
        return dispatch_group_wait(group, SecondsFromNow(seconds)) == 0
    }
    
    public func waitForever() -> Bool {
        return dispatch_group_wait(group, DISPATCH_TIME_FOREVER) == 0
    }
    
    public func notifyOnQueue(queue: DispatchQueue, block: dispatch_block_t) {
        dispatch_group_notify(group, queue.queue, block)
    }
    
    public func notify(queue: DispatchQueue, block: dispatch_block_t) {
        if let queue = asyncQueue {
            dispatch_group_notify(group, queue.queue, block)
        } else {
            assertionFailure("No async queue is set for this group")
        }
    }
}