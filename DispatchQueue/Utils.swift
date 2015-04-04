//
//  Utils.swift
//  DispatchQueue
//
//  Created by Abdulmunaf Chhatra on 4/3/15.
//  Copyright (c) 2015 Abdulmunaf Chhatra. All rights reserved.
//

import Foundation

func SecondsFromNow(seconds: UInt) -> dispatch_time_t {
    let nanoseconds = Int64(seconds) * Int64(NSEC_PER_SEC)
    return dispatch_time(DISPATCH_TIME_NOW, nanoseconds)
}