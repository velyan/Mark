//
//  SourceList.swift
//  Mark
//
//  Created by Velislava Yanchina on 10/24/16.
//  Copyright © 2016 Velislava Yanchina. All rights reserved.
//

import Foundation

protocol NavigationItemProtocol {
    var title: String {get set}
}

struct NavigationItem: NavigationItemProtocol{
    internal var title: String
}

struct HeaderNavigationItem : NavigationItemProtocol {
    internal var title: String
}
