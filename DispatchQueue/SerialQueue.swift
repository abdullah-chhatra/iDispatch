//
//  SerialQueue.swift
//  DispatchQueue
//
//  Created by Abdulmunaf Chhatra on 4/3/15.
//  Copyright (c) 2015 Abdulmunaf Chhatra. All rights reserved.
//

import Foundation

public class SerialQueue : DispatchQueue {
    
    public init(label: String) {
        super.init(queue: dispatch_queue_create(label, nil))
    }
}