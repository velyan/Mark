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
    static let protocolStatementString = "(:.*)(\\{|\n)"
}

extension NSRegularExpression {
    
    func matches(in input: String) -> [NSTextCheckingResult]? {
        let range = NSRange(0 ..< input.characters.count)
        return self.matches(in: input, options: .reportProgress, range: range)
    }
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
                var protocolsString = (line as NSString).substring(with: range)
                protocolsString = protocolsString.replacingOccurrences(of: ":", with: "")
                protocolsString = protocolsString.replacingOccurrences(of: "{", with: "")
                protocolsString = protocolsString.replacingOccurrences(of: "\n", with: "")

                let protocols = protocolsString.components(separatedBy: ":").last
                if let protocolNames = protocols?.components(separatedBy: ",") {
                    for name in protocolNames {
                        linesToInsert.append("\n//MARK: \(name)\n")
                    }
                }
            }
            result.append(MarkTuple(index, linesToInsert))
        }
 
        return result
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
