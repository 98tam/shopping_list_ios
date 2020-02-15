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
        switch entriesTableView.isEditing {
            case true:
                editButton.setTitle("Done", for: .normal)
            case false:
                editButton.setTitle("Edit", for: .normal)
        }
    }
    
    @IBAction func clearList(_ sender: UIButton) {
        let alert = UIAlertController(title: "Clear List", message: "Are you sure to delete all entries?", preferredStyle: .alert)
        self.present(alert, animated: true)
        
        let delete = UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            self.deleteAllData()
            
            self.entries.removeAll()
            self.boughtEntries.removeAll()
            
            self.entriesTableView.reloadData()
            self.boughtEntriesTableView.reloadData()
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(delete)
        alert.addAction(cancel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let view = segue.destination
        if let vc = view as? ListEntryViewController{
            vc.listType = self.listType
            vc.countEntries = entries.count
        }
    }
        
    func loadData() {
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDelegate.persistentContainer.viewContext
        let fec:NSFetchRequest = ListEntry.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "orderPosition", ascending: true)
        fec.sortDescriptors = [sortDescriptor]
        self.entries = try! context.fetch(fec)

        let items = entries
        
        self.entries = (items.filter {
            $0.listType?.id == listType?.id &&
                $0.bought == false
            })
        
        self.boughtEntries = (items.filter {
            $0.listType?.id == listType?.id &&
            $0.bought == true
            })
                        
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
            } catch {
                print(NSError.description())
            }
            entries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
            
            var i = 0
            for entry in entries {
                entry.orderPosition = Int32(i)
                i = i+1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.row > destinationIndexPath.row {
            for i in destinationIndexPath.row..<sourceIndexPath.row {
                entries[i].setValue(i+1, forKey: "orderPosition")
            }
            entries[sourceIndexPath.row].setValue(destinationIndexPath.row, forKey: "orderPosition")
        }
        
        if sourceIndexPath.row < destinationIndexPath.row{
            for i in sourceIndexPath.row + 1...destinationIndexPath.row {
                entries[i].setValue(i-1, forKey: "orderPosition")
            }
            entries[sourceIndexPath.row].setValue(destinationIndexPath.row, forKey: "orderPosition")
        }
        loadData()
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
