//
//  SourceEditorCommand.swift
//  MarkExtension
//
//  Created by Velislava Yanchina on 10/20/16.
//  Copyright © 2016 Velislava Yanchina. All rights reserved.
//

import Foundation
import XcodeKit

fileprivate extension XCSourceTextBuffer {
    var emptySelection: Bool {
        let textRange = self.selections.firstObject as! XCSourceTextRange
        return (textRange.start.line == textRange.end.line && textRange.start.column == textRange.end.column)
    }
    
    var isSwiftSource: Bool {
        return (self.contentUTI == "public.swift-source") || (self.contentUTI == "com.apple.dt.playground")
    }
    
    func appendSelectedLine(string: String) {
        let lineIndex = (self.selections.firstObject as! XCSourceTextRange).start.line
        var line = self.lines[lineIndex] as! String
        line = line.trimmingCharacters(in: CharacterSet.newlines)
        line.append(string)
        self.lines.replaceObject(at: lineIndex, with: line)
        updateSelections(line: line)
    }
    
    fileprivate func updateSelections(line: String) {
        let lineIndex = (self.selections.firstObject as! XCSourceTextRange).start.line
        let position = XCSourceTextPosition(line: lineIndex, column: line.characters.count-1)
        let range = XCSourceTextRange(start: position, end: position)
        self.selections.replaceObject(at: 0, with: range)
    }
}

struct CommandIdentifier {
    static let markAll = "MarkAllCommand"
    static let markSelected = "MarkSelectedCommand"
}

enum MarkError: Error {
    case unsupportedSource(String)
}

struct MarkErrorDesciptions {
    static let unsupportedSource = "Source code language is currently unsupported."
}

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        
        let buffer = invocation.buffer
        if buffer.isSwiftSource == false {
            completionHandler(MarkError.unsupportedSource(MarkErrorDesciptions.unsupportedSource))
        }
        
        var marksToInsert = [Any]()
        if invocation.commandIdentifier.contains(CommandIdentifier.markAll) {
            marksToInsert = MarkParser.parse(buffer: buffer)
        }
        else if invocation.commandIdentifier.contains(CommandIdentifier.markSelected) {
           marksToInsert = MarkParser.parse(buffer: buffer, options: .SelectionOnly)
        }
        insert(input: marksToInsert, into: buffer, with: invocation)

        completionHandler(nil)
    }
    
    func insert(input: [Any], into buffer: XCSourceTextBuffer, with invocation: XCSourceEditorCommandInvocation) {
        var insertedLinesCount = 0
        for mark in (input as! [MarkTuple]) {
            if isEmptySelectionCommandInvocation(buffer: buffer, with: invocation) {
                buffer.appendSelectedLine(string: mark.lines.last!)
            } else {
                let lineIndex = mark.lineIndex + 1
                for markLine in mark.lines {
                    buffer.lines.insert(markLine, at: lineIndex + insertedLinesCount)
                    insertedLinesCount += 1
                }
            }
        }
    }

    func isEmptySelectionCommandInvocation(buffer: XCSourceTextBuffer, with invocation: XCSourceEditorCommandInvocation) -> Bool {
        return (buffer.emptySelection && invocation.commandIdentifier.contains(CommandIdentifier.markSelected))
    }
}
