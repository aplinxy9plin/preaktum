//
//  CardViewController.swift
//  Easy Pay
//
//  Created by Никита Аплин on 07.12.2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//
/*
import UIKit
// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
class CardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        labelCardText.text = cardText.text
        labelName.text = nameText.text
        labelDate.text = date.text
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var cardText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var cvv: UITextField!
    @IBOutlet weak var labelCardText: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelName: UILabel!
    //override func 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.cardText.delegate = self as! UITextFieldDelegate
        // Dispose of any resources that can be recreated.
    }
    @IBAction func editing(_ sender: Any) {
        labelCardText.text = cardText.text
        if(labelCardText.text?.count == 4){
            labelCardText.text = labelCardText.text! + " "
            cardText.text = cardText.text! + " "
        }
        //print(cardText.text)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //textField code
        
        cardText.resignFirstResponder()  //if desired
        performAction()
        return true
    }
    
    func performAction() {
        //action events
        print(cardText.text)
    }
    @IBAction func addCard(_ sender: Any) {
        if(cardText.text != ""){
            QRScannerController.global.card = cardText.text!
            QRScannerController.global.cardName = nameText.text!
            QRScannerController.global.cardDate = date.text!
            QRScannerController.global.cardCVV = cvv.text!
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
*/
