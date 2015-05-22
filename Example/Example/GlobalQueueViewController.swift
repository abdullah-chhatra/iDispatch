//
//  GlobalQueueViewController.swift
//  Example
//
//  Created by Abdulmunaf Chhatra on 5/21/15.
//  Copyright (c) 2015 Abdulmunaf Chhatra. All rights reserved.
//

import UIKit
import iDispatch

class GlobalQueueViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func executeAgain() {
        textView.text = ""
        
        BackgroundQueue.dispatchAsync {
            self.printMessage("Background Queue", times: 10)
        }
        
        LowPriorityQueue.dispatchAsync {
            self.printMessage("Low Priority Queue", times: 10)
        }
        
        DefaultPriorityQueue.dispatchAsync {
            self.printMessage("Default Priority Queue", times: 10)
        }
        
        HighPrioriytQueue.dispatchAsync {
            self.printMessage("High Priority Queue", times: 10)
        }

    }
    
    func printMessage(message: String, times: UInt) {
        for i in 1...times {
            sleep(1)
            addText(message);
        }
    }

    func addText(text: String) {
        
        let message =  self.textView.text + text + "\r\n"
        MainQueue.dispatchAsync {
            println(text)
            self.textView.text = message
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
