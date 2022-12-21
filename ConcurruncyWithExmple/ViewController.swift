//
//  ViewController.swift
//  ConcurruncyWithExmple
//
//  Created by Anand Upadhyay on 20/12/22.
//

import UIKit

class MyThread: Thread {
    let waiter = DispatchGroup()

    override func start() {
        waiter.enter()
        super.start()
    }

    override func main() {
        task()
        waiter.leave()
    }

    func task() {
            let start = Date.now
            for _ in 0...100500 {
                if isCancelled {
                    let seconds = Double(Date.now.timeIntervalSince(start))
                    print("Cancelled after \(seconds) seconds")
                    exit()
                }
                Thread.sleep(forTimeInterval: 0.01) // Long task
            }
    }
    
    func join() {
        waiter.wait()
    }
    
    func exit() {
            waiter.leave()
            Thread.exit()
        }
}

class ViewController: UIViewController {
    let thread = MyThread()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testThreading()
        serialisedQuest()
        concurrentQueue()
        messagerQueue()
        // Do any additional setup after loading the view.
    }

    func messagerQueue(){
        
        let messenger = Messenger()
        // Executed on Thread #1
        messenger.postMessage("Hello SwiftLee!")
        // Executed on Thread #2
        print(messenger.lastMessage!)
    }
    
    func testThreading(){
        DispatchQueue.global().asyncAfter(
            deadline: .now().advanced(by: .seconds(5))) {
                self.thread.cancel()
        }
        thread.start()

        thread.join()

    }
    
    
    func serialisedQuest(){
        let serialQueue = DispatchQueue(label: "swiftlee.serial.queue")

        serialQueue.async {
            print("Task 1 started")
            // Do some work..
            print("Task 1 finished")
        }
        serialQueue.async {
            print("Task 2 started")
            // Do some work..
            print("Task 2 finished")
        }
    }
    
    func concurrentQueue(){
        let concurrentQueue = DispatchQueue(label: "swiftlee.concurrent.queue", attributes: .concurrent)

        concurrentQueue.async {
            print("Task 1 started")
            // Do some work..
            print("Task 1 finished")
        }
        concurrentQueue.async {
            print("Task 2 started")
            // Do some work..
            print("Task 2 finished")
        }
    }
    
    
    //Async Await
    func testAsyncAwait(){
        
//        let namesMain = await downloadNames(fromServer: "main")
//        let secondary = await downloadNames(fromServer: "secondary")
        //above line gives error - async call in a function that does not support concurrency

        
        let handle = Task { // Creates asynchronous task
            let names = await downloadNames(fromServer: "main")
            
            Task { // Creates asynchronous task
                await save(names: names)
            }
            
            for name in names {
                print(name)
            }
        }
        if handle.isCancelled{
            print("Task Cancelled")
        }
    }
    
    func save(names: [String]) async {
        print("Saved:\(names)")
    }
    
    func dijkstr(){
        let Q = PriorityQueue<Int, Int> { (p1: Int, p2: Int) -> (Bool) in
            return p1 > p2
        }
        let n = 999
        for i in 0...n - 1 {
            let start = NSDate().timeIntervalSince1970
            Q.enqueue(i, i)
            let end = NSDate().timeIntervalSince1970
            print(end - start)
        }
    }
//    func taskGroup(){
//        let calculations = await withTaskGroup(of: Int.self) { group -> Int in
//            group.addTask { 1 * 2 } // () -> Int
//            group.addTask { 2 * 3 }
//            group.addTask { 3 * 4 }
//            group.addTask { 4 * 5 }
//            group.addTask { 5 * 6 }
//
//            var collected = [Int]()
//
//            for await value in group {
//                collected.append(value)
//            }
//
//            return collected
//        }
//    }
    
    func downloadNames(fromServer name: String) async -> [String] {
        let data = "some data to be loaded"
        return Array(arrayLiteral: data)
    }

}

 

