//
//  SerialQueue.swift
//  DispatchQueue
//
//  Created by Abdulmunaf Chhatra on 4/3/15.
//  Copyright (c) 2015 Abdulmunaf Chhatra. All rights reserved.
//

import Foundation

/**
    This class represents a serial queue.
*/
public class SerialQueue : DispatchQueue {
   
    /**
        Designated initializer to create a new serial queue.
    
        :param: label   Label or name for the new serial queue to be created.
    */
    public init(label: String) {
        super.init(queue: dispatch_queue_create(label, nil))
    }
    
    /**
        This initializer could be used to create a new SerialQueue object to work with already
        created serial queue.
    
        :param: queue   Existing GCD serial queue.
    */
    public override init(queue: dispatch_queue_t) {
        super.init(queue: queue)
    }
}