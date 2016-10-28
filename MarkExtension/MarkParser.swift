//
//  SourceEditorTextParser.swift
//  Mark
//
//  Created by Velislava Yanchina on 10/20/16.
//  Copyright © 2016 Velislava Yanchina. All rights reserved.
//

import Foundation
import XcodeKit

fileprivate struct MarkRegExPattern {
    
    static let protocolStatementLine = "(class|struct|extension|protocol)(.*:.*,.*)"
    static let protocolStatementString = ":.*"
}

extension NSRegularExpression {
    
    func matches(in input: String) -> [NSTextCheckingResult]? {
        let range = NSRange(0 ..< input.characters.count)
        return self.matches(in: input, options: .reportProgress, range: range)
    }
}

extension String {
    func alphabeticalString() -> String {
        let chars =  CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789").inverted
        let string = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return string.trimmingCharacters(in: chars)
    }
    
    func fromCamelCase() -> String {
        let range = self.range(of: self)
        var string = self.replacingOccurrences(of: "([a-z])([A-Z])",
                                               with: "$1 $2",
                                               options: .regularExpression,
                                               range:range)
        for (idx, chr) in self.characters.enumerated() {
            let str = String(chr)
            if str.lowercased() == str && idx > 0 {
                let index = string.characters.index(string.characters.startIndex, offsetBy: idx - 1)
                string = string.replacingOccurrences(of: string.substring(to: index), with: "")
                break
            }
        }
        

        return string
    }
}

enum MarkParserOptions {
    case IgnoreSelection
    case SelectionOnly
}

typealias MarkTuple = (lineIndex: Int, lines: [String] )

class MarkParser {
    
    static var protocolStringRegEx = try! NSRegularExpression(pattern: MarkRegExPattern.protocolStatementString, options: .caseInsensitive)
    static var protocolLineRegEx = try! NSRegularExpression(pattern: MarkRegExPattern.protocolStatementLine, options: .caseInsensitive)
    
    static func parse(buffer: XCSourceTextBuffer) -> [Any] {
        var result = [MarkTuple]()
        let lineIndexes = lineIndexesToParse(buffer: buffer) as! [Int]
        for index in lineIndexes {
            var linesToInsert = [String]()

            let line = buffer.lines[index] as! String
            if let match = protocolStringRegEx.matches(in: line)?.first {
                let range = match.range
                let substring = (line as NSString).substring(with: range)
                linesToInsert = parse(string: substring)
            }
            result.append(MarkTuple(index, linesToInsert))
        }
 
        return result
    }
    
    static func parse(buffer: XCSourceTextBuffer, options: MarkParserOptions) -> [Any] {
        var result = [Any]()
        
        switch options {
        case .IgnoreSelection:
            result = parse(buffer: buffer)
        case .SelectionOnly:
            result = parseSelections(buffer: buffer)
        }
        return result
    }

    //MARK: - Private methods
    fileprivate static func parseSelections(buffer: XCSourceTextBuffer) -> [Any] {
        var marks = [MarkTuple]()
        for textRange in buffer.selections {
            let range = textRange as! XCSourceTextRange
            var selectionString = ""
            let startLine = range.start.line
            let endLine = range.end.line
            
            for line in startLine...endLine {
                let lineString = (buffer.lines.count > line) ? buffer.lines[line] as! NSString : ""
                let rangeStart = (line == startLine) ?  range.start.column : 0
                let rangeEnd = (line == endLine) ? range.end.column + 1 : lineString.length
                selectionString.append(lineString.substring(with: NSMakeRange(rangeStart, rangeEnd - rangeStart)))
            }
            
            let result = parse(string: selectionString)
            marks.append(MarkTuple(range.end.line, result))
        }
        
        return marks
    }
    
    fileprivate static func parse(string: String) -> [String] {
        var linesToInsert = [String]()
        let protocols = string.components(separatedBy: ":").last
        if let protocolNames = protocols?.components(separatedBy: ",") {
            for name in protocolNames {
                let protocolName = name.alphabeticalString().fromCamelCase()
                linesToInsert.append("\n    //MARK: - \(protocolName)\n")
            }
        }
        return linesToInsert
    }
    
    fileprivate static func lineIndexesToParse(buffer: XCSourceTextBuffer) -> [Any] {
        var matches = [Int]()
        for lineIndex in 0 ..< buffer.lines.count {
            let line = buffer.lines[lineIndex] as! String
            let result = protocolLineRegEx.matches(in: line)
            if let _ = result, (result?.count)! > 0  {
                matches.append(lineIndex)
            }
        }
        return matches
    }
    
}
