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
    
    func createNewItem(with title: String) {
        let newItem = Item(context: PersistenceController.shared.viewContext)
        newItem.id = UUID().uuidString
        newItem.title = title
        newItem.createdAt = Date()
        newItem.completedAt = nil
        PersistenceController.shared.saveContext()
    }
    
    func fetchIncompleteItems() -> [Item] {
        // Create the fetch request
        let fetchRequest = Item.fetchRequest()
        // Add the predicate for either incomplete or complete
        fetchRequest.predicate = NSPredicate(format: "completedAt == nil")
        
        // Add sort direction
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let context = PersistenceController.shared.viewContext
        // Execute the fetch request on a context (view context)
        let fetchedItems = try? context.fetch(fetchRequest)
        // If the fetch request fails, return an empty array of Items
        return fetchedItems ?? []
    }
    
    func fetchCompletedItems() -> [Item] {
        let fetchRequest = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "completedAt != nil")
        
        // Add sort direction
        let sortDescriptor = NSSortDescriptor(key: "completedAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        let context = PersistenceController.shared.viewContext
        let fetchedItems = try? context.fetch(fetchRequest)
        return fetchedItems ?? []
    }
    
    func toggleItemCompletion(_ item: Item) {
        item.completedAt = item.isCompleted ? nil : Date()
        PersistenceController.shared.saveContext()
    }
    
    func delete(at indexPath: IndexPath) {
        remove(item(at: indexPath))
    }
    
    func remove(_ item: Item) {
        let context = PersistenceController.shared.viewContext
        context.delete(item)
        PersistenceController.shared.saveContext()
    }

    private func item(at indexPath: IndexPath) -> Item {
        let items = indexPath.section == 0 ? fetchIncompleteItems() : fetchCompletedItems()
        return items[indexPath.row]
    }

}
