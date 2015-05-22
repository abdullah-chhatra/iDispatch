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

Create a serial queue by instantiatinig SericalQueue. 
