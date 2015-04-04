//
//  ConcurrentQueue.swift
//  DispatchQueue
//
//  Created by Abdulmunaf Chhatra on 4/3/15.
//  Copyright (c) 2015 Abdulmunaf Chhatra. All rights reserved.
//

import Foundation

public typealias apply_block_t = (UInt) -> Void

public class ConcurrentQueue : DispatchQueue {
    
    public init(label: String) {
        super.init(queue: dispatch_queue_create(label, DISPATCH_QUEUE_CONCURRENT))
    }
    
    public func dispatchBarrierAsync(block: dispatch_block_t) -> ConcurrentQueue {
        dispatch_barrier_async(queue, block)
        return self
    }
    
    public func dispatchBarrierSync(block: dispatch_block_t) -> ConcurrentQueue {
        dispatch_barrier_sync(queue, block)
        return self
    }
    
    public func apply(iterations: UInt, block: apply_block_t) {
        dispatch_apply(iterations, queue, block)
    }
    
    public func applySync<T>(array: [T], block: (t: T) -> Void) {
        apply(UInt(array.count), block: { (index) -> Void in
            block(t: array[Int(index)])
        })
    }
    
    public func applyAsync<T>(array: [T], block: (t: T) -> Void, completion: (() -> Void)? = nil) {
        let group = DispatchGroup(asyncQueue: self)
        for arr in array {
            group.dispatchAsync {
                block(t: arr)
            }
        }
        
        if let completionBlock = completion {
            group.notify(self, block: completionBlock)
        }
    }
    
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
    
    public func mapAsync<T, U>(array: [T], block: (t: T) -> U, mapped: (m: [U]) -> Void) {
        var dict = [Int : U]()
        
        let group = DispatchGroup(asyncQueue: self)
        for (index, arr) in enumerate(array) {
            group.dispatchAsync {
                 dict[index] = block(t: arr)
            }
        }
        
        group.notify(self, block: { () -> Void in
            
            var m = [U]()
            for i in 0...array.count - 1 {
                m.append(dict[i]!)
            }
            mapped(m: m)
        })
        
    }
}