//
//  URLSessionTaskOperation.swift
//  AssetCaching
//
//  Created by David Livadaru on 06/09/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import Foundation

private var URLSessionTaskOperationKVOContext = 0

class URLSessionTaskOperation: Operation {
    let task: URLSessionTask

    init(task: URLSessionTask) {
        assert(task.state == .suspended, "Tasks must be suspended.")
        self.task = task

        super.init()
    }

    // MARK: Operation overrides

    override func start() {
        super.start()

        if isCancelled {
            finish()
        }
    }

    override func main() {
        if isCancelled {
            finish()
        } else {
            execute()
        }
    }

    override var isExecuting: Bool {
        return task.state == .running || task.state == .suspended
    }

    override var isFinished: Bool {
        return task.state == .canceling || task.state == .completed
    }

    override func cancel() {
        task.cancel()

        super.cancel()
    }

    // MARK: Private methods

    private func execute() {
        task.addObserver(self, forKeyPath: "state", options: [], context: &URLSessionTaskOperationKVOContext)

        willChangeValue(forKey: "isExecuting")
        task.resume()
        didChangeValue(forKey: "isExecuting")
    }

    private func finish() {
        willChangeValue(forKey: "isExecuting")
        willChangeValue(forKey: "isFinished")
        didChangeValue(forKey: "isExecuting")
        didChangeValue(forKey: "isFinished")
    }

    // MARK: Task state KVO

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        guard context == &URLSessionTaskOperationKVOContext, let object = object as? URLSessionTask else { return }

        if object === task && keyPath == "state" && task.state == .completed {
            task.removeObserver(self, forKeyPath: "state")
            finish()
        }
    }
}
