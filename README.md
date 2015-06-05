# iDispatch

This is an easy to use wrapper over GCD is iOS. It not only provides simple and intuitive wrapper over dispatch_async for global queues but also other useful constructs and concepts like groups, timer, custom serial and concurrent queues.

As this is a wrapper over GCD all the GCD concepts and limitations apply to the library. If you are not familiar with GCD please go through following links:

https://developer.apple.com/library/ios/documentation/Performance/Reference/GCD_libdispatch_Ref/
http://www.raywenderlich.com/60749/grand-central-dispatch-in-depth-part-1

## Installation

If you are using cocoapods then add the following line to your pod file:

```
pod 'iDsipatch'
```

Alternatively you could include project iDispatch/iDispatch.xcodeproj into you workspace or copy files of directory iDispatch/iDispatch/ into your project.

## Serial Queues

If you would like to execute blocks/tasks sequentially you could do so using SerialQueue class. Following code shows usage of SerialQueue class:

```swift
let queue = SerialQueue(label: "MySerialQueue")

//Execute task asynchronously on this queue
queue.dispatchAsync {
    println("This will be executed asynchronously")
}

//Execute task synchronously on this queue
queue.dispatchSync {
    println("This will be executed synchronously")
}

//Execute task after number of seconds
queue.dispatchAfterSeconds(3) {
    println("This will be executed after 3 seconds")
}

//Suspend queue
queue.suspend()

//Resume queue
queue.resume()

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
    println("This block will be executed after all the task submitted to this queue before this block are finished")
}

//Executing barrier block synchronously
queue.dispatchBarrierSync {
    println("This block will be executed after all the task submitted to this queue before this block are finished")
}

```

### Apply blocks for iterations

If you want to perform concurrent operations over an array you could make use of apply blocks. It is assumed that each iteration is independent of eachother. Following code demonstrates it:

```swift
let queue = ConcurrentQueue(label: "MyConcurrentQueue") 

let imageFiles: [String] = getImagesToBeProcessed() //Some method that will return image file paths that needs to be processed.

//This will block the current thread till all the images are processed. 
queue.applySync(imageFiles) { (imageFile) -> Void in
    //Process this image file here. 
}

//This will NOT block the current thread, completion block will be executed after all the images are processed.
queue.applySync(imageFiles, block: { (imageFile) -> Void in
    //Process this image file here. 
}) {
    //Do any post processing here.
}
```

#### Map operations using apply blocks

Another application for apply blocks is to execute map operations concurrently on an array. Following code demonstrates it:

```swift
let queue = ConcurrentQueue(label: "MyConcurrentQueue") 

let messages: [String] = //Some messages to map

//This method will block till all the map operations are over.
let mapped = queue.mapSync(messages, block: { (message) -> String in
                //Process message here
                return processedMessage.
            })
            
//This method will NOT block, mapped block will be executed when all the mapp operations are finished.
queue.mapAsync(messages, block: { (message) -> String in
            //Process message here
            return processedMessage.
        }) { (mapped) -> Void in
            //Do something with message
        }
```
You many have different type of mapping array and mapped array, here it both are kept String for the sake of simplicity.

## Dispatch Groups

From Apple documentation of GCD for dispatch groups

> Grouping blocks allows for aggregate synchronization. Your application can submit multiple blocks and track when they all complete, even though they might run on different queues. This behavior can be helpful when progress can’t be made until all of the specified tasks are complete.

You could use DispatchGroup class to access this feature of GCD. A DispatchGroup could be created with or without binding to any perticular queue. If it is bound to a perticular queue all submitted task/blocks will be executed on that queue.

```
let queue1 = ConcurrentQueue(label: "MyConcurrentQueue")
let queue2 = ConcurrentQueue(label: "OtherConcurrentQueue")

let group = DispatchGroup(queue: queue1)

//Eexecute block on the queue that was passed to initializer. 
group.dispatchAync {
    //Some work to do here
}

//Execute block on different queue.
group.dispatchAsyncOnQueue(queue2) {
    //Some more work to do on different queue
}

//To wait for specified seconds for all the blocks to finish.
group.waitForSeconds(10)

//To wait indefinitly for all the blocks to finish.
group.waitForever()




```
