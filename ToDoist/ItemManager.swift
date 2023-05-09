//
//  ItemManager.swift
//  ToDoist
//
//  Created by Parker Rushton on 10/21/22.
//

import Foundation
import CoreData

class ItemManager {
    static let shared = ItemManager()
    
    //    var allItems = [Item]()
    //    var items: [Item] {
    //        allItems.filter { $0.completedAt == nil }.sorted(by: { $0.sortDate >  $1.sortDate })
    //    }
    //    var completedItems: [Item] {
    //        allItems.filter { $0.completedAt != nil }.sorted(by: { $0.sortDate >  $1.sortDate })
    //    }
    
    
    // Funcs
    
    func createNewItem(with title: String, in toDoList: ToDoList) {
        let newItem = Item(context: PersistenceController.shared.viewContext)
        newItem.id = UUID().uuidString
        newItem.title = title
        newItem.createdAt = Date()
        newItem.completedAt = nil
        newItem.toDoList = toDoList
        PersistenceController.shared.saveContext()
    }
    
    func incompleteItems(of toDoList: ToDoList) -> [Item] {
        toDoList.itemsArray
            .filter { $0.isCompleted == false }
            .sorted { $0.sortDate > $1.sortDate }
    }
    
    func completedItems(of toDoList: ToDoList) -> [Item] {
        toDoList.itemsArray
            .filter { $0.isCompleted == true }
            .sorted { $0.sortDate > $1.sortDate }
    }
    
//    func fetchIncompleteItems() -> [Item] {
//        // Create the fetch request
//        let fetchRequest = Item.fetchRequest()
//        // Add the predicate for either incomplete or complete
//        fetchRequest.predicate = NSPredicate(format: "completedAt == nil")
//
//        // Add sort direction
//        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//
//        let context = PersistenceController.shared.viewContext
//        // Execute the fetch request on a context (view context)
//        let fetchedItems = try? context.fetch(fetchRequest)
//        // If the fetch request fails, return an empty array of Items
//        return fetchedItems ?? []
//    }
//
//    func fetchCompletedItems() -> [Item] {
//        let fetchRequest = Item.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "completedAt != nil")
//
//        // Add sort direction
//        let sortDescriptor = NSSortDescriptor(key: "completedAt", ascending: false)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//
//        let context = PersistenceController.shared.viewContext
//        let fetchedItems = try? context.fetch(fetchRequest)
//        return fetchedItems ?? []
//    }
    
    func toggleItemCompletion(_ item: Item) {
        item.completedAt = item.isCompleted ? nil : Date()
        PersistenceController.shared.saveContext()
    }
    
    func delete(item: Item) {
        PersistenceController.shared.viewContext.delete(item)
        PersistenceController.shared.saveContext()
    }

    // MARK: ToDoList CRUD
    
    func createNewToDoList(with title: String) -> ToDoList {
        let newToDo = ToDoList(context: PersistenceController.shared.viewContext)
        newToDo.title = title
        newToDo.createdAt = Date()
        newToDo.id = UUID().uuidString
        newToDo.modifiedAt = Date()
        PersistenceController.shared.saveContext()
        return newToDo
    }
    
    func fetchToDoLists() -> [ToDoList] {
        let fetchRequest = ToDoList.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "modifiedAt", ascending: false)]
        
        let context = PersistenceController.shared.viewContext
        let fetchedItems = try? context.fetch(fetchRequest)
        return fetchedItems ?? []
    }
    
    func updateToDoList(_ toDoList: ToDoList) {
        PersistenceController.shared.saveContext()
    }
    
    func delete(toDoAt indexPath: IndexPath) {
        remove(toDoList(at: indexPath))
    }
    
    func remove(_ toDoList: ToDoList) {
        let context = PersistenceController.shared.viewContext
        context.delete(toDoList)
        PersistenceController.shared.saveContext()
    }
    
    private func toDoList(at indexPath: IndexPath) -> ToDoList {
        let toDoLists = fetchToDoLists()
        return toDoLists[indexPath.row]
    }
    
}
