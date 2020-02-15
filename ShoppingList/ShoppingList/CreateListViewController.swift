//
//  CreateListViewController.swift
//  ShoppingList
//
//  Created by Theresa Ganser on 01.02.20.
//  Copyright © 2020 Theresa Ganser. All rights reserved.
//

import UIKit

class CreateListViewController: UIViewController {
    @IBOutlet weak var listTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveNewList(_ sender: UIButton) {
        if listTextField.text!.isEmpty {
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let item = ListType(context: context)
        item.listName = listTextField.text
        item.id = UUID()
        appDelegate.saveContext()
        navigationController?.popViewController(animated: true)
    }
}
