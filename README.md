# iDispatch

This is an easy to use wrapper over GCD is iOS. It not only provieds simple and intutive wrapper over dispatch_async for global queues but also other usefull constructs and cocepts like groups, timer, custom serail and concurrent queues.

As this is a wrapper over GCD all the GCD concepts and limitations apply to the library. If you are not familiar with GCD please go through following links:

https://developer.apple.com/library/ios/documentation/Performance/Reference/GCD_libdispatch_Ref/
http://www.raywenderlich.com/60749/grand-central-dispatch-in-depth-part-1

## Installation

If you are using cocoapods then add the following line to your pod file:

```
pod 'iDsipatch'
```

Alternatively you could include project iDispatch/iDispatch.xcodeproj into you worspace or copy files of directory iDispatch/iDispatch/ into your project.

## Serial Queues

If you would like to execute blocks/tasks sequentially you could do so using SerialQueue class. Following code shows usage of SerialQueue class:

```
let queue = SerialQueue(label: "MySerialQueue")

//Execute task asynchronously on this queue
queue.dispatchAsync {
    prinln("This will be executed asynchronously")
}

//Execute task synchronously on this queue
queue.dispatchSync {
    prinln("This will be executed synchronously")
}

//Execute taks after number of seconds
queue.dispatchAfterSeconds(3) {
    prinln("This will be executed after 3 seconds")
}
```

## Concurrent Queues

If you would like to execute blocks/tasks concurrently you could do so using ConcurrentQueue class. Apart from all the method of SerialQueue this class provides rich set of methods that covers other GCD concepts viz. barriers and apply blocks. 

### Barriers
From Apple documentation of GCD about barriers:

> A dispatch barrier allows you to create a synchronization point within a concurrent dispatch queue. When it encounters a barrier, a concurrent queue delays the execution of the barrier block (or any further blocks) until all blocks submitted before the barrier finish executing. At that point, the barrier block executes by itself. Upon completion, the queue resumes its normal execution behavior.

```swift
let queue = ConcurrentQueue(label: "MyConcurrentQueue") 

//Execute block asynchronously on this queue
queue.dispatchAsync {
    println("Async task to be executed")
}

//Executing barrier block asynchronously
queue.dispatchBarrierAsync {
    println("This block will be exeuted after all the task sumbitted to this queue before this block are finished")
}

//Executing barrier block synchronously
queue.dispatchBarrierSync {
    println("This block will be exeuted after all the task sumbitted to this queue before this block are finished")
}

```

### Apply blocks for iterations

