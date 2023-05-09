//
//  ViewController.swift
//  ToDoist
//
//  Created by Parker Rushton on 10/15/22.
//

import UIKit

class ItemsViewController: UIViewController {
    
    enum TableSection: Int {
        case incomplete, complete
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties

    private let itemManager = ItemManager.shared
    private let toDoList: ToDoList
    private lazy var datasource: ItemDataSource = {
        let datasource = ItemDataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.reuseIdentifier) as! ItemTableViewCell
            cell.update(with: item)
            cell.delegate = self
            return cell
        }
        datasource.delegate = self
        return datasource
    }()

    // MARK: - Initializers
    
    init?(coder: NSCoder, toDoList: ToDoList) {
        self.toDoList = toDoList
        
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init:(coder:toDoList:) to initialize ItemsViewController")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = datasource
        generateNewSnapshot()
    }

}


// MARK: - Item Cell Delegate

extension ItemsViewController: ItemCellDelegate {

    func completeButtonPressed(item: Item) {
        itemManager.toggleItemCompletion(item)
        generateNewSnapshot()
    }
    
}


// MARK: - ItemDelegate

extension ItemsViewController: ItemDelegate {
    
    func deleteItem(at indexPath: IndexPath) {
        let itemToDelete = item(at: indexPath)
        ItemManager.shared.delete(item: itemToDelete)
        generateNewSnapshot()
    }
    
    func item(at indexPath: IndexPath) -> Item {
        let section = TableSection(rawValue: indexPath.section)!
        switch section {
        case .incomplete:
            return ItemManager.shared.incompleteItems(of: toDoList)[indexPath.row]
        case .complete:
            return ItemManager.shared.completedItems(of: toDoList)[indexPath.row]
        }
    }
    
}


// MARK: - TextField Delegate

extension ItemsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return true }
        itemManager.createNewItem(with: text, in: toDoList)
        textField.text = ""
        generateNewSnapshot()
        return true
    }
    
}


// MARK: - Private

private extension ItemsViewController {
    
    func generateNewSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<TableSection, Item>()
        
        let incompleteItems = ItemManager.shared.incompleteItems(of: toDoList)
        let completedItems = ItemManager.shared.completedItems(of: toDoList)
        
        if !incompleteItems.isEmpty {
            snapshot.appendSections([.incomplete])
            snapshot.appendItems(incompleteItems, toSection: .incomplete)
        }
        if !completedItems.isEmpty {
            snapshot.appendSections([.complete])
            snapshot.appendItems(completedItems, toSection: .complete)
        }
        DispatchQueue.main.async {
            self.datasource.apply(snapshot)
        }
    }
    
}
