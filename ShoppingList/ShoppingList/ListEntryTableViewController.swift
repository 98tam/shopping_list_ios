//
//  ListEntryTableViewController.swift
//  ShoppingList
//
//  Created by Theresa Ganser on 02.02.20.
//  Copyright © 2020 Theresa Ganser. All rights reserved.
//

import UIKit
import CoreData

class ListEntryTableViewController: UIViewController {
    @IBOutlet weak var entriesTableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var boughtEntriesTableView: UITableView!
    
    var userDefaults = UserDefaults.standard
    var entries: [ListEntry] = []
    var boughtEntries: [ListEntry] = []
    var listType: ListType?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        loadData()
    }
    
    @IBAction func editCells(_ sender: UIButton) {
        entriesTableView.isEditing = !entriesTableView.isEditing
    }
    
    @IBAction func clearList(_ sender: UIButton) {
        self.deleteAllData()
        
        entries.removeAll()
        boughtEntries.removeAll()
        
        entriesTableView.reloadData()
        boughtEntriesTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let view = segue.destination
        if let vc = view as? ListEntryViewController{
            vc.listType = self.listType
        }
    }
        
    func loadData(){
        let items = fetchAllData()
        
        self.entries = (items?.filter {
            $0.listType?.id == listType?.id &&
                $0.bought == false
            })!
        self.boughtEntries = items?.filter {
            $0.listType?.id == listType?.id &&
            $0.bought == true
            } ?? []
                        
        entriesTableView.reloadData()
        boughtEntriesTableView.reloadData()
    }
    
    func fetchAllData() -> [ListEntry]? {
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDelegate.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ListEntry")
                
        do {
            return try context.fetch(fetch) as? [ListEntry]
        } catch {
            print ("There was an error")
        }
        appDelegate.saveContext()
        return nil
    }
    
    func deleteAllData() {
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ListEntry")

        do {
            try context.fetch(deleteFetch)
            for entry in (entries + boughtEntries) {
                context.delete(entry)
            }
            try context.save()
        } catch {
            print ("There was an error")
        }
        appDelegate.saveContext()

    }
    func updateEntry(entry:ListEntry){
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDelegate.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ListEntry")
        fetch.predicate = NSPredicate(format:"id = %@",entry.id! as CVarArg)
        
        do {
            var result = try context.fetch(fetch).first as? ListEntry
            if result != nil {
                result = entry
            }
            try context.save()
        } catch {
            print ("There was an error")
        }
        appDelegate.saveContext()
    }
    
    @IBAction func markBought(_ sender: UIButton) {
        let tag = sender.tag
        entries[tag].bought = true
        updateEntry(entry: entries[tag])
        loadData()
    }
    
    @IBAction func markUnbought(_ sender: UIButton) {
        let tag = sender.tag
        boughtEntries[tag].bought = false
        updateEntry(entry: boughtEntries[tag])
        loadData()
    }
}

extension ListEntryTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == entriesTableView {
            return entries.count
        }
        else if tableView == boughtEntriesTableView {
            return boughtEntries.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var item:ListEntry = ListEntry()
        var cell:ListEntryCell = ListEntryCell()

        if tableView == entriesTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "listEntryCell", for: indexPath) as! ListEntryCell
            item = entries[indexPath.row]
        }
        else if  tableView == boughtEntriesTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "boughtCell", for: indexPath) as! ListEntryCell
            item = boughtEntries[indexPath.row]        
        }
        
        if cell.buyButton != nil{
            cell.buyButton.tag = indexPath.row
            cell.listEntryLabel?.text = item.name ?? ""
            cell.unitsLabel?.text = item.amount.description + " " + (item.unit ?? "0")
            cell.iconView = UIImageView(image: UIImage(named: item.icon ?? "mixer"))
            cell.iconView.frame = CGRect(x: 10,y: 10,width: 40,height: 40)
            cell.addSubview(cell.iconView)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
            appDelegate.persistentContainer.viewContext.delete(entries[indexPath.row])
            do {
                try  appDelegate.persistentContainer.viewContext.save()
            } catch is NSError {
                print(NSError.description())
            }
            entries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let entry = entries[sourceIndexPath.row]
        entries.remove(at: sourceIndexPath.row)
        entries.insert(entry, at: destinationIndexPath.row)
        
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        
        let name = entries[sourceIndexPath.row].name
        let amount = entries[sourceIndexPath.row].amount
        let unit = entries[sourceIndexPath.row].unit
        let icon = entries[sourceIndexPath.row].icon
        
        entries[sourceIndexPath.row].name = entries[destinationIndexPath.row].name
        entries[sourceIndexPath.row].amount = entries[destinationIndexPath.row].amount
        entries[sourceIndexPath.row].unit = entries[destinationIndexPath.row].unit
        entries[sourceIndexPath.row].icon = entries[destinationIndexPath.row].icon
        
        entries[destinationIndexPath.row].name = name
        entries[destinationIndexPath.row].amount = amount
        entries[destinationIndexPath.row].unit = unit
        entries[destinationIndexPath.row].icon = icon
        
        appDelegate.saveContext()
        entriesTableView.isEditing = false
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
