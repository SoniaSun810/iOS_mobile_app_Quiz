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

    override func viewDidLoad() {
        super.viewDidLoad()
        print(ImageStore.shareImageStore)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Add NavigationItem on NavBar
        self.tableView.reloadData() 
        self.parent?.navigationItem.title = "Set Numerical Questions"
        self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(self.addAction))

        self.parent?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.editAction))
    }
    
    
    @objc func addAction() {
        let editItemController = EditItemController(isEditMode: true, itemDetail: nil)
        self.navigationController?.pushViewController(editItemController, animated: true)
//        self.present(editItemController, animated: true)
    }
    
    
    // Editing Mode: Reordering and deleting
    @objc func editAction() {
        if isEditing {
            self.parent?.navigationItem.leftBarButtonItem?.title = "Edit"
            setEditing(false, animated: true)
        } else {
            self.parent?.navigationItem.leftBarButtonItem?.title = "Done"
            setEditing(true, animated: true)
            Items.sharedInstance.editMode = true
        }
    }

    
    // Implement table view row deletion
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ImageStore.shareImageStore.deleteImage(forKey: Items.sharedInstance.items[indexPath.row].itemKey)
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
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print("you tapped me")
        let item = Items.sharedInstance.items[indexPath.row]
        let detailContoller = EditItemController(isEditMode: false, itemDetail: item)
        self.navigationController?.pushViewController(detailContoller, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


