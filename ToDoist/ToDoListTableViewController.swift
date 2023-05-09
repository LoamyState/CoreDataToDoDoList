//
//  ToDoListTableViewController.swift
//  ToDoist
//
//  Created by J Madsen on 5/2/23.
//

import UIKit

class ToDoListTableViewController: UITableViewController {
    
    var toDoLists: [ToDoList] = []
    var selectedToDo: ToDoList?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        toDoLists = ItemManager.shared.fetchToDoLists()
        tableView.reloadData()
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
                
        let toDoList = toDoLists[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = toDoList.title
        content.secondaryText = String(toDoList.itemsArray.count)
        cell.contentConfiguration = content
        
        return cell
    }


    @IBAction func addToDoList(_ sender: Any) {
        showAlert()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Name your To-Do List", message: nil, preferredStyle: .alert)
        alert.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alert] _ in
            let answer = alert.textFields![0]
            
            self.selectedToDo = ItemManager.shared.createNewToDoList(with: answer.text ?? "")

            self.performSegue(withIdentifier: "toDoListSegue", sender: nil)
            
        }
        
        alert.addAction(submitAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    
    @IBSegueAction func showToDoList(_ coder: NSCoder, sender: Any?) -> ItemsViewController? {
        
        guard let selectedToDo else { return nil }
        
        return ItemsViewController(coder: coder, toDoList: selectedToDo)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedToDo = toDoLists[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "toDoListSegue", sender: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
