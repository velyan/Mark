//
//  Content.swift
//  Mark
//
//  Created by Velislava Yanchina on 10/24/16.
//  Copyright © 2016 Velislava Yanchina. All rights reserved.
//

import Foundation

typealias ResourceTuple = (name: String, extension: String)

struct Content {
    var title: String
    var description: String
    var resource: ResourceTuple
}
