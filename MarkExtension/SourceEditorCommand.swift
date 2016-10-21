//
//  SourceEditorCommand.swift
//  MarkExtension
//
//  Created by Velislava Yanchina on 10/20/16.
//  Copyright © 2016 Velislava Yanchina. All rights reserved.
//

import Foundation
import XcodeKit

struct CommandIdentifier {
    static let markAll = "MarkAllCommand"
    static let markSelected = "MarkSelectedCommand"
}

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        
        let buffer = invocation.buffer
        var marksToInsert = [Any]()
        
        if invocation.commandIdentifier.contains(CommandIdentifier.markAll) {
            marksToInsert = MarkParser.parse(buffer: buffer)
        }
        else if invocation.commandIdentifier.contains(CommandIdentifier.markSelected) {
           marksToInsert = MarkParser.parse(buffer: buffer, options: .SelectionOnly)
        }
        insert(input: marksToInsert, into: buffer)

        completionHandler(nil)
    }
    
    
    func insert(input: [Any], into buffer: XCSourceTextBuffer) {
        var insertedLinesCount = 0
        for mark in (input as! [MarkTuple]) {
            let lineIndex = mark.lineIndex + 2
            
            for markLine in mark.lines {
                buffer.lines.insert(markLine, at: lineIndex + insertedLinesCount)
                insertedLinesCount += 2
            }
        }
    }

    
}
