//
//  ViewController.swift
//  ShoppingList
//
//  Created by Tamara Zieher on 18.12.19.
//  Copyright © 2019 Tamara Zieher. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.performSegue(withIdentifier: "goToOverview", sender: self.view)
        }
    }
}

