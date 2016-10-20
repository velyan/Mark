//
//  SourceEditorTextParser.swift
//  Mark
//
//  Created by Velislava Yanchina on 10/20/16.
//  Copyright © 2016 Velislava Yanchina. All rights reserved.
//

import Foundation
import XcodeKit

extension NSRegularExpression {
    static func match(pattern: String, against input: String) -> [NSTextCheckingResult]? {
        var results = [NSTextCheckingResult]()
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(0 ..< input.characters.count)
            results = regex.matches(in: input, options: .reportProgress, range: range)
        } catch {
            print(error.localizedDescription)
        }
        return results
    }
}

typealias SourceTextTuple = (lineIndex: Int, lines: [String] )

class SourceEditorTextParser {
    
    // Finds lines of code that define a structure that implements protocols
    static func parse(buffer: XCSourceTextBuffer) -> [Any] {
        var result = [SourceTextTuple]()
        let lineIndexes = lineIndexesToParse(buffer: buffer) as! [Int]
        for index in lineIndexes {
            var linesToInsert = [String]()

            let line = buffer.lines[index] as! String
            let pattern = "(:.*)(\\{|\n)"
            if let match = NSRegularExpression.match(pattern: pattern, against: line)?.first {
                let range = match.range
                var protocolsString = (line as NSString).substring(with: range)
                protocolsString = protocolsString.replacingOccurrences(of: ":", with: "")
                protocolsString = protocolsString.replacingOccurrences(of: "{", with: "")
                protocolsString = protocolsString.replacingOccurrences(of: "\n", with: "")

                let protocols = protocolsString.components(separatedBy: ":").last
                if let protocolNames = protocols?.components(separatedBy: ",") {
                    for name in protocolNames {
                        linesToInsert.append("//MARK: \(name)\n\n")
                    }
                }
            }
            result.append(SourceTextTuple(index, linesToInsert))
        }
 
        return result
    }
    
    fileprivate static func lineIndexesToParse(buffer: XCSourceTextBuffer) -> [Any] {
        var matches = [Int]()
        for lineIndex in 0 ..< buffer.lines.count {
            let line = buffer.lines[lineIndex] as! String
            let pattern = "(class|struct|extension)(.*:.*,.*)"
            let result = NSRegularExpression.match(pattern: pattern, against: line)
            if let _ = result, (result?.count)! > 0  {
                matches.append(lineIndex)
            }
        }
        return matches
    }
}
