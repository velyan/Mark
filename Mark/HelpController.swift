//
//  HelpController.swift
//  Mark
//
//  Created by Velislava Yanchina on 10/24/16.
//  Copyright © 2016 Velislava Yanchina. All rights reserved.
//

import Foundation

fileprivate enum Strings {
    static let installation = "Installation"
    static let keyBindingsSetup = "Key Bindings Setup"
    static let howToSetUp = "HOW TO SETUP?"
    static let installationDescription = "1. Open System Preferences\n2. Select Extensions > Xcode Source Editor\n3. Enable Mark"
    static let keyBindingsDescription = "1. Open Xcode > Preferences\n2. Select Key Bindings from the top bar\n3. Filter by \"mark\" and double tap the result to edit key bindings"
}

fileprivate enum Resources {
    static let step1Video = (name: "system_prefs_demo", extension: "mov")
    static let step2Video = (name: "key_bindings_demo", extension: "mov")
}

fileprivate enum Contents {
    static let installation = Content(title: Strings.installation,
                                      description: Strings.installationDescription,
                                      resource: Resources.step1Video)
    static let keyBindings = Content(title: Strings.keyBindingsSetup,
                                      description: Strings.keyBindingsDescription,
                                      resource: Resources.step2Video)
}

protocol HelpControllerDelegate: class {
    func reloadContent(content: Content)
}

class HelpController {
    weak var delegate: HelpControllerDelegate?
    lazy var data = [HeaderNavigationItem(title: Strings.howToSetUp),
                     NavigationItem(title: Strings.installation),
                     NavigationItem(title: Strings.keyBindingsSetup)] as [Any]
    
    public func action(forItem item: NavigationItemProtocol) {
        if let content = content(forNavigationItem: item) {
            delegate?.reloadContent(content: content)
        }
    }
    
    func content(forNavigationItem item: NavigationItemProtocol) -> Content? {
        if item.title == Strings.installation {
            return Contents.installation
        }
        else if item.title == Strings.keyBindingsSetup {
            return Contents.keyBindings
        }
        return nil
    }
}
