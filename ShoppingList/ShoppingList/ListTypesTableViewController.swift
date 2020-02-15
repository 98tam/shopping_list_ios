//
//  ListTypesTableViewController.swift
//  ShoppingList
//
//  Created by Theresa Ganser on 01.02.20.
//  Copyright © 2020 Theresa Ganser. All rights reserved.
//

import UIKit
import CoreData

class ListTypesTableViewController: UITableViewController {
    
    var userDefaults = UserDefaults.standard
    var listItems: [ListType] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<ListType>(entityName: "ListType")
        if let items = try? context.fetch(request) {
            self.listItems = items
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listTypeCell", for: indexPath) as! ListTypeCell
        let item = listItems[indexPath.row]
        cell.listItemLabel?.text = item.listName
        return cell
    }

   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let view = segue.destination
        if let vc = view as? ListEntryTableViewController{
            vc.listType = listItems[tableView.indexPathForSelectedRow!.row]
            vc.title = listItems[tableView.indexPathForSelectedRow!.row].listName
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
            appDelegate.persistentContainer.viewContext.delete(listItems[indexPath.row])
            do {
                try  appDelegate.persistentContainer.viewContext.save()
            } catch {
                print(NSError.description())
            }
            listItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        }
    }
}
