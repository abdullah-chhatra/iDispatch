//
//  DispatchGroup.swift
//  DispatchQueue
//
//  Created by Abdulmunaf Chhatra on 4/3/15.
//  Copyright (c) 2015 Abdulmunaf Chhatra. All rights reserved.
//

import Foundation

/**
    Represents a dispatch group.
*/
public class DispatchGroup {
    
    let group: dispatch_group_t
    
    let asyncQueue: DispatchQueue?
  
    /**
        Designated initializer that creates a new GCD dispatch group.
    */
    public init() {
        group = dispatch_group_create()
    }
    
    /**
        Designated initializer that creates a new GCD dispatch group. The queue passed to it
        will be used to executes async block for this group.
    
        :param: asyncQueue  This queue will be used to execute async blocks for this group.
    */
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

    /**
        Executes the block synchronously on the current thread. It will enter group before executing 
        the block and leave group after the block is finished.
    
        :param: block   Block to be executed.
    */
    public func dispatchSync(block: dispatch_block_t) {
        enter()
        block()
        leave()
    }
    
    /**
        Dispatches the block asynchronously on its designated async queue.
    
        :param: block   Block to be executed.
    */
    public func dispatchAsync(block: dispatch_block_t) {
        if let queue = asyncQueue {
            dispatch_group_async(group, queue.queue, block)
        } else {
            assertionFailure("No async queue is set for this group")
        }
    }
    
    /**
        Dispatches the block asynchronously on specified queue.
    
        :param: block   Block to be executed.
    */
    public func dispatchAsyncOnQueue(queue: DispatchQueue, block: dispatch_block_t) {
        dispatch_group_async(group, queue.queue, block)
    }
    
    /**
        Waits for number of seconds for the group to finish. 
    
        :param: seconds Nubmer of seconds to wait for the group to finish.
    
        :returns:       True if group returns before specified seconds, false otherwise.
    */
    public func waitForSeconds(seconds: UInt) -> Bool {
        return dispatch_group_wait(group, SecondsFromNow(seconds)) == 0
    }
    
    /**
        Waits forever for the group to finish.
    */
    public func waitForever() -> Bool {
        return dispatch_group_wait(group, DISPATCH_TIME_FOREVER) == 0
    }
    
    /**
        Schedules a block to be submitted to specified queue when the group finishes.
    
        :param: queue   Queue on wich the block is to be submitted.
    
        :param: block   Completion block that is to be called.
    */
    public func notifyOnQueue(queue: DispatchQueue, block: dispatch_block_t) {
        dispatch_group_notify(group, queue.queue, block)
    }
    
    
    /**
        Schedules a block to be submitted to designated async queue when the group finishes.
    
        :param: block   Completion block that is to be called.
    */
    public func notify(block: dispatch_block_t) {
        if let queue = asyncQueue {
            dispatch_group_notify(group, queue.queue, block)
        } else {
            assertionFailure("No async queue is set for this group")
        }
    }
}