//
//  DispatchQueue.swift
//  DispatchQueue
//
//  Created by Abdulmunaf Chhatra on 4/3/15.
//  Copyright (c) 2015 Abdulmunaf Chhatra. All rights reserved.
//

import Foundation

/**
    Base class for dispatch queues that provides basic operations to execute blocks.
    This class must be treated as abstract class and should not be instantiated directly.
**/
public class DispatchQueue {
    
    public let label: String
    
    let queue: dispatch_queue_t
    
    public init(queue: dispatch_queue_t) {
        self.queue = queue
        self.label = String.fromCString(dispatch_queue_get_label(queue))!
    }
    
    /**
        Dispatches the block passed to the queue to be executed asynchronously.
    
        :param: block
                Block to be executed.
    */
    public func dispatchAsync(block: dispatch_block_t) -> Self {
        dispatch_async(queue, block)
        return self
    }
    
    /**
        Dispatches the block passed to the queue to be executed synchronously.
    
        :param: block
                Block to be executed.
    */
    public func dispatchSync(block: dispatch_block_t) -> Self {
        dispatch_sync(queue, block)
        return self
    }
    
    /**
        Dispatches the block passed to the queue to be executed after seconds specified.
    
        :param: block
                Block to be executed.
    */
    public func dispatchAfterSeconds(seconds: UInt, block: dispatch_block_t) -> Self {
        dispatch_after(SecondsFromNow(seconds), queue, block)
        return self
    }
    
    /**
        Suspends this queue
    */
    public func suspend() {
        dispatch_suspend(queue)
    }
    
    /**
        Resumes this queue
    */
    public func resume() {
        dispatch_resume(queue)
    }
}

func SecondsFromNow(seconds: UInt) -> dispatch_time_t {
    let nanoseconds = Int64(seconds) * Int64(NSEC_PER_SEC)
    return dispatch_time(DISPATCH_TIME_NOW, nanoseconds)
}