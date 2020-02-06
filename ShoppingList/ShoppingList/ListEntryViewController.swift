//
//  ListEntryViewController.swift
//  ShoppingList
//
//  Created by Theresa Ganser on 02.02.20.
//  Copyright © 2020 Theresa Ganser. All rights reserved.
//

import UIKit
import CoreData

class ListEntryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var entryTextField: UITextField!
    @IBOutlet weak var unitsTextField: UITextField!
    @IBOutlet weak var unitsPicker: UIPickerView!
    @IBOutlet weak var amountText: UITextField!
    @IBOutlet weak var scroller: UIScrollView!
    
    var units = ["pcs.", "kg", "litre"]
    
    var listType: ListType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        unitsPicker.isHidden = true
        view.addSubview(scroller)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scroller.contentSize = CGSize(width: scroller.contentSize.width, height: 800)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addSubview(scroller)
        scroller.contentSize = CGSize(width: scroller.contentSize.width, height: 800)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        guard let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }
        let keyboardFrame = view.convert(keyboardFrameValue.cgRectValue, from: nil)
        scroller.contentOffset = CGPoint(x:0, y:keyboardFrame.size.height)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return units.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return units[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.unitsTextField.text = self.units[row]
        self.unitsPicker.isHidden = true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.unitsTextField {
            self.unitsPicker.isHidden = false
            //if you dont want the users to se the keyboard type:
            textField.endEditing(true)
        }
    }
    
    
    @IBAction func saveEntry(_ sender: UIButton) {
        if entryTextField.text!.isEmpty {
            return
        }
        else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let item = ListEntry(context: context)
                        
            item.name = entryTextField.text
            let amount = amountText.text?.toDouble()
            item.amount = amount ?? 0.0
            item.unit = unitsTextField.text
            item.listType = listType
            item.id = UUID()
            
            var imageName: String?
            if (selectedButton == nil) {
                imageName = "mixer"
            }
            else {
                imageName = selectedButton.restorationIdentifier
            }
            item.icon = imageName
                
            appDelegate.saveContext()
            navigationController?.popViewController(animated: true)
        }
    }

    @IBOutlet weak var hideCoke: UIButton!
    @IBOutlet weak var hideBeer: UIButton!
    @IBOutlet weak var hideBread: UIButton!
    @IBOutlet weak var hideGarlic: UIButton!
    @IBOutlet weak var hideTomato: UIButton!
    @IBOutlet weak var hideLollipop: UIButton!
    @IBOutlet weak var hideCoffee: UIButton!
    @IBOutlet weak var hideCheese: UIButton!
    @IBOutlet weak var hideSalt: UIButton!
    @IBOutlet weak var hideBanana: UIButton!
    @IBOutlet weak var hideGrapes: UIButton!
    @IBOutlet weak var hideTea: UIButton!
    @IBOutlet weak var hideSpaghetti: UIButton!
    @IBOutlet weak var hideWine: UIButton!
    @IBOutlet weak var hideDogFood: UIButton!
    @IBOutlet weak var hideMuffin: UIButton!
    @IBOutlet weak var hidePeach: UIButton!
    @IBOutlet weak var hideMeat: UIButton!
    @IBOutlet weak var hideBroccoli: UIButton!
    @IBOutlet weak var hideMixer: UIButton!
    @IBOutlet weak var hidePizza: UIButton!
    @IBOutlet weak var hidePudding: UIButton!
    @IBOutlet weak var hideSugar: UIButton!
    @IBOutlet weak var hideBaby: UIButton!
    
    var selectedButton: UIButton!
    
    @IBAction func selectButton(_ sender: UIButton) {
        unselectAll()
        switch sender {
            case hideCoke:
                hideCoke.isHidden = true
                selectedButton = hideCoke
            case hideBeer:
                hideBeer.isHidden = true
                selectedButton = hideBeer
            case hideBread:
                hideBread.isHidden = true
                selectedButton = hideBread
            case hideGarlic:
                hideGarlic.isHidden = true
                selectedButton = hideGarlic
            case hideTomato:
                hideTomato.isHidden = true
                selectedButton = hideTomato
            case hideLollipop:
                hideLollipop.isHidden = true
                selectedButton = hideLollipop
            case hideCoffee:
                hideCoffee.isHidden = true
                selectedButton = hideCoffee
            case hideCheese:
                hideCheese.isHidden = true
                selectedButton = hideCheese
            case hideSalt:
                hideSalt.isHidden = true
                selectedButton = hideSalt
            case hideBanana:
                hideBanana.isHidden = true
                selectedButton = hideBanana
            case hideGrapes:
                hideGrapes.isHidden = true
                selectedButton = hideGrapes
            case hideTea:
                hideTea.isHidden = true
                selectedButton = hideTea
            case hideSpaghetti:
                hideSpaghetti.isHidden = true
                selectedButton = hideSpaghetti
            case hideWine:
                hideWine.isHidden = true
                selectedButton = hideWine
            case hideDogFood:
                hideDogFood.isHidden = true
                selectedButton = hideDogFood
            case hideMuffin:
                hideMuffin.isHidden = true
                selectedButton = hideMuffin
            case hidePeach:
                hidePeach.isHidden = true
                selectedButton = hidePeach
            case hideMeat:
                hideMeat.isHidden = true
                selectedButton = hideMeat
            case hideBroccoli:
                hideBroccoli.isHidden = true
                selectedButton = hideBroccoli
            case hideMixer:
                hideMixer.isHidden = true
                selectedButton = hideMixer
            case hidePizza:
                hidePizza.isHidden = true
                selectedButton = hidePizza
            case hidePudding:
                hidePudding.isHidden = true
                selectedButton = hidePudding
            case hideSugar:
                hideSugar.isHidden = true
                selectedButton = hideSugar
            case hideBaby:
                hideBaby.isHidden = true
                selectedButton = hideBaby
            default:
                return
        }
    }
    
    @IBAction func unselectButton(_ sender: UIButton) {
        switch sender.tag {
            case 1:
                hideCoke.isHidden = false
            case 2:
                hideBeer.isHidden = false
            case 3:
                hideBread.isHidden = false
            case 4:
                hideGarlic.isHidden = false
            case 5:
                hideTomato.isHidden = false
            case 6:
                hideLollipop.isHidden = false
            case 7:
                hideCoffee.isHidden = false
            case 8:
                hideCheese.isHidden = false
            case 9:
                hideSalt.isHidden = false
            case 10:
                hideBanana.isHidden = false
            case 11:
                hideGrapes.isHidden = false
            case 12:
                hideTea.isHidden = false
            case 13:
                hideSpaghetti.isHidden = false
            case 14:
                hideWine.isHidden = false
            case 15:
                hideDogFood.isHidden = false
            case 16:
                hideMuffin.isHidden = false
            case 17:
                hidePeach.isHidden = false
            case 18:
                hideMeat.isHidden = false
            case 19:
                hideBroccoli.isHidden = false
            case 20:
                hideMixer.isHidden = false
            case 21:
                hidePizza.isHidden = false
            case 22:
                hidePudding.isHidden = false
            case 23:
                hideSugar.isHidden = false
            case 24:
                hideBaby.isHidden = false
            default:
                return
        }
    }
    
    func unselectAll() {
        hideCoke.isHidden = false
        hideBeer.isHidden = false
        hideBread.isHidden = false
        hideGarlic.isHidden = false
        hideTomato.isHidden = false
        hideLollipop.isHidden = false
        hideCoffee.isHidden = false
        hideCheese.isHidden = false
        hideSalt.isHidden = false
        hideBanana.isHidden = false
        hideGrapes.isHidden = false
        hideTea.isHidden = false
        hideSpaghetti.isHidden = false
        hideWine.isHidden = false
        hideDogFood.isHidden = false
        hideMuffin.isHidden = false
        hidePeach.isHidden = false
        hideMeat.isHidden = false
        hideBroccoli.isHidden = false
        hideMixer.isHidden = false
        hidePizza.isHidden = false
        hidePudding.isHidden = false
        hideSugar.isHidden = false
        hideBaby.isHidden = false
    }
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
     }
}
