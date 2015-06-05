//
//  ViewController.swift
//  Example
//
//  Created by Abdulmunaf Chhatra on 5/20/15.
//  Copyright (c) 2015 Abdulmunaf Chhatra. All rights reserved.
//

import UIKit
import iDispatch

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    let ITEM_CELL = "ITEM_CELL"
    
    let items = [   "Main Queue",
                    "Global Queues",
                    "Serial Queus",
                    "Concurrent Queues",
                    "Concurrent Queues - Barrier",
                    "Concurrent Queues - Apply Sync",
                    "Concurrent Queues - Apply Async",
                    "Concurrent Queues - Map Sync",
                    "Concurrent Queues - Map Async"]

    
    let printQueue = SerialQueue(label: "print_queue")
    
    let serialQueue1 = SerialQueue(label: "serial_queue_1")
    let concurrentQueue1 = ConcurrentQueue(label: "concurrent_queue_1")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: ITEM_CELL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ITEM_CELL, forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {        
        switch indexPath.row {
        case 0:
            showAlertInMainQueue()
            break
            
        case 1:
            exampleGlobalQueues()
            break
            
        case 2:
            exampleSerialQueues()
            break
            
        case 3:
            exampleConcurrentQueue()
            break
            
        case 4:
            exampleConcurrentBarrier()
            break
            
        case 5:
            exampleConcurrentApplySync()
            break
        
        case 6:
            exampleConcurrentApplyAsync()
            break
            
        case 7:
            exampleConcurrentMapSync()
            break
            
        case 8:
            exampleConcurrentMapAsync()
            break
            
        default:
            break
        }
    }
    
    func showAlertInMainQueue() {
        MainQueue.dispatchAsync {
            let ac = UIAlertController(title: "iDispatch Example", message: "This is shown from Main Queue", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    func exampleGlobalQueues() {
        
        BackgroundQueue.dispatchAsync {
            self.printMessage("Background Queue - Example Global Queue", times: 10)
        }
        
        LowPriorityQueue.dispatchAsync {
            self.printMessage("Low Priority Queue - Example Global Queue", times: 10)
        }
        
        DefaultPriorityQueue.dispatchAsync {
            self.printMessage("Default Priority Queue - Example Global Queue", times: 10)
        }

        HighPrioriytQueue.dispatchAsync {
            self.printMessage("High Priority Queue - Example Global Queue", times: 10)
        }
    }
    
    func exampleSerialQueues() {
        serialQueue1.dispatchAfterSeconds(1) {
            self.printMessage("Serial Queue after 5 sec         - Serial Queue", times: 5)
        }

        serialQueue1.dispatchAsync {
            self.printMessage("Serial Queue Async               - Serial Queue", times: 5)
        }
        printMessage("This will be printed before Async")
        
        serialQueue1.dispatchSync {
            self.printMessage("Serial Queue Sync                - Serial Queue", times: 5)
        }
        printMessage("This will be printed after Sync")
    }
    
    func exampleConcurrentQueue() {
        concurrentQueue1.dispatchAfterSeconds(5) {
            self.printMessage("Concurrent Queue after 5 sec     - Concurrent Queue", times: 5)
        }

        concurrentQueue1.dispatchAsync {
            self.printMessage("Serial Queue Async 1             - Concurrent Queue", times: 5)
        }
        printMessage("This will be printed before Async 1")
        
        concurrentQueue1.dispatchAsync {
            self.printMessage("Serial Queue Async 2             - Concurrent Queue", times: 5)
        }
        printMessage("This will be printed before Async 2")
        
        concurrentQueue1.dispatchSync {
            self.printMessage("Serial Queue Sync                - Concurrent Queue", times: 5)
        }
        printMessage("This will be printed after Sync")
    }
    
    func exampleConcurrentBarrier() {
        concurrentQueue1.dispatchAsync {
            self.printMessage("Serial Queue Async 1             - Concurrent Queue", times: 5)
        }
        
        concurrentQueue1.dispatchAsync {
            self.printMessage("Serial Queue Async 2             - Concurrent Queue", times: 5)
        }

        concurrentQueue1.dispatchBarrierAsync {
            self.printMessage("Serial Queue Barrier Async       - Concurrent Queue", times: 5)
        }
        
        concurrentQueue1.dispatchAsync {
            self.printMessage("Serial Queue Async 3             - Concurrent Queue", times: 5)
        }
        
        concurrentQueue1.dispatchBarrierSync {
            self.printMessage("Serial Queue Barrier Sync        - Concurrent Queue", times: 5)
        }

        concurrentQueue1.dispatchAsync {
            self.printMessage("Serial Queue Async 4             - Concurrent Queue", times: 5)
        }
    }
    
    func exampleConcurrentApplySync() {
        var messages = ["Message - 1", "Message - 2", "Message - 3", "Message - 4", "Message - 5"]
        
        concurrentQueue1.applySync(messages) { (imageFile) -> Void in
            
        }
        concurrentQueue1.applySync(messages, block: { (t) -> Void in
            self.printMessage(t)
        })
        printMessage("This will be printed after interations")
    }
    
    func exampleConcurrentApplyAsync() {
        var messages = ["Message - 1", "Message - 2", "Message - 3", "Message - 4", "Message - 5"]
        
        concurrentQueue1.applyAsync(messages, block: { (t) -> Void in
            self.printMessage(t)
            }) {
                self.printMessage("All the interations are completed")
            }
        printMessage("This will be printed before interations")
    }

    func exampleConcurrentMapSync() {
        var messages = ["Message - 1", "Message - 2", "Message - 3", "Message - 4", "Message - 5"]
        
        var mapped = concurrentQueue1.mapSync(messages, block: { (t) -> String in
            self.printMessage(t)
            return "Mapped \(t)"
        })
        for m in mapped {
            println(m)
        }
    }
    
    func exampleConcurrentMapAsync() {
        var messages = ["Message - 1", "Message - 2", "Message - 3", "Message - 4", "Message - 5"]
        
        concurrentQueue1.mapAsync(messages, block: { (t) -> String in
            self.printMessage(t)
            return "Mapped \(t)"
        }) { (mapped) -> Void in
            for m in mapped {
                println(m)
            }
        }
    }

    func printMessage(message: String, times: UInt) {
        for i in 1...times {
            printMessage(message)
        }
    }
    
    func printMessage(message: String) {
        printQueue.dispatchSync {
            sleep(1)
            println(message)
        }
    }
}
