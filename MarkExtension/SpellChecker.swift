//
//  SpellChecker.swift
//  MarkExtension
//
//  Created by Velislava Yanchina on 29/12/17.
//  Copyright © 2017 Velislava Yanchina. All rights reserved.
//

import AppKit

struct SpellChecker {
//    let checker: NSSpellChecker = NSSpellChecker.shared()
    
    static func check() {
        let checker = NSSpellChecker.shared()
        
        checker.checkSpelling(of: "is htis bullshit?", startingAt: 0)
    }
}
