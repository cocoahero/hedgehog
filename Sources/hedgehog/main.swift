//
//  main.swift
//  Hedgehog
//
//  Created by Jonathan Baker on 4/2/20.
//  Copyright © 2020 Jonathan Baker. All rights reserved.
//

import Foundation
import ArgumentParser

class Hedgehog : ParsableCommand {

    @Option(name: .customShort("n"), default: 10, help: "The number of lines to display.")
    var lines: Int
    
    @Flag(name: .shortAndLong, help: "Follow file and display new lines.")
    var follow: Bool
    
    @Option(name: .shortAndLong, help: "Path to the file you want to read.")
    var path: String
    
    required init() {}

    func run() throws {
        let fileURL = URL(fileURLWithPath: path)
        
        let handle = try FileHandle(forReadingFrom: fileURL)
        
        var lineBuffer = [String]()
        
        handle.seekToEndOfFile()
        try handle.readLinesReversed { (line, shouldContinue) in
            lineBuffer.append(line)
            shouldContinue = lineBuffer.count < lines
        }
        
        lineBuffer.reversed().forEach { print($0) }
        
        if follow {
            handle.seekToEndOfFile()
            NotificationCenter.default.addObserver(self, selector: #selector(dataAvailable), name: .NSFileHandleDataAvailable, object: handle)
            handle.waitForDataInBackgroundAndNotify()
            RunLoop.main.run()
        }
    }
    
    @objc func dataAvailable(notification: Notification) {
        if let handle = notification.object as? FileHandle {
            let data = handle.availableData
            if !data.isEmpty {
                print(String(data: data, encoding: .utf8)!.trimmingCharacters(in: .newlines))
            }
            handle.waitForDataInBackgroundAndNotify()
        }
    }
}

extension FileHandle {
    /// Reads data from the current receiver's offset in reverse order, separating lines by `\n` using the specified encoding. The scan will continue until
    /// the beginning of the file is reached, or the boolean passed to the callback closure has been set to `false`.
    func readLinesReversed(encoding: String.Encoding = .utf8, handler: (String, inout Bool) -> Void) throws {
        var shouldRead = true
        var lineBuffer = Data()
        let newLine = "\n".data(using: encoding)!
        var offset = offsetInFile
        
        while shouldRead {
            try seek(toOffset: offset)
            
            let data = readData(ofLength: 1)
            
            if data == newLine {
                if !lineBuffer.isEmpty {
                    lineBuffer.reverse()
                    handler(String(data: lineBuffer, encoding: encoding)!, &shouldRead)
                    lineBuffer = Data()
                }
            } else {
                lineBuffer.append(data)
            }
            
            if offset > 0 {
                offset = offset - 1
            } else { break }
        }
    }
}

Hedgehog.main()
