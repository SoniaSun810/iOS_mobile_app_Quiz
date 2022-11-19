//
//  ItemsViewController.swift
//  quiz
//
//  Created by 孙丰楠 on 2022/11/17.
//
// Get access to the correct ViewController by getting an array of the root
// view controller displayed by the tab bar interface, UITabBarController

import UIKit

class ItemsViewController: UITableViewController {
    
    @IBOutlet var numericalTableView: UITableView!
//    var itemStore : ItemStore!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        
    }
    

    // Editing Mode
    @IBAction func toggleEditing(_ sender: UIButton) {
        if isEditing {
            sender.setTitle("Edit", for: .normal)
            setEditing(false, animated: true)
        } else {
            sender.setTitle("Done", for: .normal)
            setEditing(true, animated: true)
            Items.sharedInstance.editMode = true
        }
    }
    
    // Implement table view row deletion
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Items.sharedInstance.items.remove(at: indexPath.row)
            //Also remove the row from the table view with an animation
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    
    
    // Implement reordering items with table view
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    func moveItem(from fromIndex : Int, to toIndex : Int) {
        if fromIndex == toIndex {
            return
        }
        let movedItem = Items.sharedInstance.items[fromIndex]
        // remove item from array
        Items.sharedInstance.items.remove(at: fromIndex)
        Items.sharedInstance.items.insert(movedItem, at: toIndex)
        
    }
    
    
    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Items.sharedInstance.items.count
    }
    
    
    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)as! TableViewCell
        
        // Configure the cell’s contents.
        cell.setQuestion(question: Items.sharedInstance.items[indexPath.row].question)
        cell.setAnswer(answer: Items.sharedInstance.items[indexPath.row].answer)
        
        // pick image
        //        UIImagePickerController(rootViewController: <#T##UIViewController#>)
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me")
        let contoller = DetailController()
        self.present(contoller, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}


