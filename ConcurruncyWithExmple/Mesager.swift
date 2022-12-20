//
//  Mesager.swift
//  ConcurruncyWithExmple
//
//  Created by Anand Upadhyay on 20/12/22.
//

import Foundation
final class Messenger {

    private var messages: [String] = []

    private var queue = DispatchQueue(label: "messages.queue", attributes: .concurrent)

    var lastMessage: String? {
        return queue.sync {
            messages.last
        }
    }

    func postMessage(_ newMessage: String) {
        queue.sync(flags: .barrier) {
            messages.append(newMessage)
        }
    }
}
