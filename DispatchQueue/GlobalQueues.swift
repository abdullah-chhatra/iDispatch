//
//  GlobalQueues.swift
//  DispatchQueue
//
//  Created by Abdulmunaf Chhatra on 4/4/15.
//  Copyright (c) 2015 Abdulmunaf Chhatra. All rights reserved.
//

import Foundation

public enum GlobalQueueIdentifier {
    
    case HighPriority
    case DefaultPriority
    case LowPriority
    case BackgroundPriority
    
    public func toGlobalIdentifier() -> Int {
        switch self {
        case .HighPriority:
            return DISPATCH_QUEUE_PRIORITY_HIGH
            
        case .DefaultPriority:
            return DISPATCH_QUEUE_PRIORITY_DEFAULT
            
        case .LowPriority:
            return DISPATCH_QUEUE_PRIORITY_LOW
            
        case .BackgroundPriority:
            return DISPATCH_QUEUE_PRIORITY_BACKGROUND
        }
    }
}

public class GlobalQueue : ConcurrentQueue {
    
    public init(identifier: GlobalQueueIdentifier) {
        super.init(queue: dispatch_get_global_queue(identifier.toGlobalIdentifier(), 0))
    }
}

public let MainQueue               = SerialQueue(queue: dispatch_get_main_queue())

public let HighPrioriytQueue       = GlobalQueue(identifier: .HighPriority)
public let DefaultPriorityQueue    = GlobalQueue(identifier: .DefaultPriority)
public let LowPriorityQueue        = GlobalQueue(identifier: .LowPriority)
public let BackgroundQueue         = GlobalQueue(identifier: .BackgroundPriority)

public let UserInteractiveQueue    = HighPrioriytQueue
public let UserInitiatedQueue      = DefaultPriorityQueue
public let UtitlityQueue           = LowPriorityQueue
