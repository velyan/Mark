//
//  SourceEditorCommand.swift
//  MarkExtension
//
//  Created by Velislava Yanchina on 10/20/16.
//  Copyright © 2016 Velislava Yanchina. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        
        let buffer = invocation.buffer
        let marksToInsert = MarkParser.parse(buffer: buffer)
        insert(input: marksToInsert, into: buffer)
        
        completionHandler(nil)
    }
    
    func insert(input: [Any], into buffer: XCSourceTextBuffer) {
        var insertedLinesCount = 0
        for mark in (input as! [MarkTuple]) {
            let lineIndex = mark.lineIndex + 1

            for markLine in mark.lines {
                buffer.lines.insert(markLine, at: lineIndex + insertedLinesCount)
                insertedLinesCount += 2
            }
        }
    }
    
}
