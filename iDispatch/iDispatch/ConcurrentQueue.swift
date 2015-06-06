//
//  ConcurrentQueue.swift
//  DispatchQueue
//
//  Created by Abdulmunaf Chhatra on 4/3/15.
//  Copyright (c) 2015 Abdulmunaf Chhatra. All rights reserved.
//

import Foundation

public typealias apply_block_t = (Int) -> Void


/**
    This class represents a concurrent queue.
*/
public class ConcurrentQueue : DispatchQueue {
  
    /**:name: Initialization */
    
    /**
        Designated initializer to create a new concurrent queue.
    
        :param: label   Label or name for the new concurrent queue to be created.
    */

    public init(label: String) {
        super.init(queue: dispatch_queue_create(label, DISPATCH_QUEUE_CONCURRENT))
    }
    
    /**
        This initializer could be used to create a new ConcurrentQueue object to work with already
        created concurrent queue.
    
        :param: queue   Existing GCD serial queue.
    */

    override init(queue: dispatch_queue_t) {
        super.init(queue: queue)
    }
    
    /**:name: Barriers */
    
    /**
        Dispatches a barrier block asynchronously on this queue. This method will return immediately.
    
        :param: block   The barrier block that is to be dispatched on this queue.
    */
    public func dispatchBarrierAsync(block: dispatch_block_t) {
        dispatch_barrier_async(queue, block)
    }
    
    /**
        Dispatches a barrier block synchronously on this queue. This method will not return until
        the block has been executed.
    
        :param: block   The barrier block that is to be dispatched on this queue.
    */
    public func dispatchBarrierSync(block: dispatch_block_t) {
        dispatch_barrier_sync(queue, block)
    }
    
    
    /**:name: Iterations */
    
    /**
        Executes the block on this queue for number of iterations passed to it. The block may execute for
        iterations concurrently so it is advised each iteration over the block is independent. This method
        will not return till all the iterations have been completed.
    
        :param: iterations  Number of times the block must be executed.
    
        :param: block       This will be called with iteration as a parameter.
    */
    public func apply(iterations: UInt, block: apply_block_t) {
        dispatch_apply(Int(iterations), queue, block)
    }
    
    /**
        Executes a block for each element of an array. Each call to block may execute concurrently.
        This method does not return till all the block have been completed.
    
        :param: array       Block is executed for each element of this array.
    
        :param: block       An element of array is passed to this block for each iteration.
    */
    public func applySync<T>(array: [T], block: (t: T) -> Void) {
        apply(UInt(array.count), block: { (index) -> Void in
            block(t: array[Int(index)])
        })
    }
    
    /**
        Executes a block for each element of an array. Each call to block may execute concurrently.
        This method returns immediately without waiting for the blocks to execute. If completion 
        parameter is not nil it will be executed when all the blocks are finished executing.
    
        :param: array       Block is executed for each element of this array.
    
        :param: block       An element of array is passed to this block for each iteration.
    
        :param: completion  If not nil, it will be called when all the blocks are finished executing.
    */
    public func applyAsync<T>(array: [T], block: (t: T) -> Void, completion: (() -> Void)? = nil) {
        let group = DispatchGroup(asyncQueue: self)
        for arr in array {
            group.dispatchAsync {
                block(t: arr)
            }
        }
        
        if let completionBlock = completion {
            group.notify(completionBlock)
        }
    }
    
    /**:name: Map operations */
    
    /**
        Executes the mapping block concurrently for each element in array. This method will wait for all
        the blocks to finish and return resultant mapped array.
    
        :param: array   Array to be mapped
    
        :param: block   Mapping block
    
        :returns:       Mapped array
    */
    public func mapSync<T, U>(array: [T], block: (t: T) -> U) -> [U] {
        var dict = [Int : U]()
        
        apply(UInt(array.count), block: { (index) -> Void in
            dict[Int(index)] = block(t: array[Int(index)])
            return
        })
        
        var mapped = [U]()
        for i in 0...array.count - 1 {
            mapped.append(dict[i]!)
        }
        return mapped
    }
    
    /**
        Executes the mapping block concurrently for each element in array. This method will return 
        immediately and the results are communicated to caller via mappen callback block.
    
        :param: array   Array to be mapped
    
        :param: block   Mapping block
    
        :param: mapped  This block will be executed when all the results are computed.
    */
    public func mapAsync<T, U>(array: [T], block: (t: T) -> U, mapped: (m: [U]) -> Void) {
        var dict = [Int : U]()
        
        let group = DispatchGroup(asyncQueue: self)
        for (index, arr) in enumerate(array) {
            group.dispatchAsync {
                 dict[index] = block(t: arr)
            }
        }

        group.notify { () -> Void in
            
            var m = [U]()
            for i in 0...array.count - 1 {
                m.append(dict[i]!)
            }
            mapped(m: m)
        }
    }
}


