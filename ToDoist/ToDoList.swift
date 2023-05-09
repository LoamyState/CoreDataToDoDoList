//
//  ToDoList.swift
//  ToDoist
//
//  Created by J Madsen on 5/2/23.
//

import Foundation

extension ToDoList {
    var itemsArray: [Item] {
        let set = items as? Set<Item> ?? []
        return Array(set)
    }
}

