//
//  MakeOrderViewController.swift
//  Bootcamp
//
//  Created by Rajat Jaic Mendus on 11/16/18.
//  Copyright © 2018 IODevelopers. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MakeOrderViewController: UIViewController {

    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var dateContainerView: UIView!
    @IBOutlet weak var itemContainerView: UIView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var biriyaniFullSwitch: UISwitch!
    @IBOutlet weak var biriyaniHalfSwitch: UISwitch!
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(MakeOrderViewController.dateChanged(datePicker:)), for: .valueChanged)
        dateTextField.inputView = datePicker
        
        biriyaniFullSwitch.setOn(false, animated: true)
        biriyaniHalfSwitch.setOn(false, animated: true)
        
        makeRoundedViewWithDropShadow(currentView: mainContainerView)
        makeRoundedViewWithDropShadow(currentView: dateContainerView)
        makeRoundedViewWithDropShadow(currentView: itemContainerView)
    }
    
    @IBAction func orderPressed(_ sender: RoundButton) {
        
        print("Order pressed")
        guard let dateSelected = dateTextField.text, dateSelected != "" else {
            print("No date selected")
            showAlert(alertTitle: "Null entry", alertMessage: "Please select a date.", alertAction: "Ok")
            return
        }
        guard let admissionID = UserDefaults.standard.string(forKey: "UserAdmissionNumber"), admissionID != "" else {
            print("Not logged in")
            return
        }
        var jsonToSend: JSON = JSON(["IDNo": admissionID, "OrderDate": dateSelected])
        if biriyaniHalfSwitch.isOn == true && biriyaniFullSwitch.isOn == true {
            let items = ["Full Biriyani": "120", "Half Biriyani": "90"]
            jsonToSend["OrderedItems"].dictionaryObject = items
        }
        else if biriyaniHalfSwitch.isOn == true || biriyaniFullSwitch.isOn == true {
            if biriyaniHalfSwitch.isOn == true {
                let items = ["Half Biriyani": "90"]
                jsonToSend["OrderedItems"].dictionaryObject = items
            }
            else {
                let items = ["Full Biriyani": "120"]
                jsonToSend["OrderedItems"].dictionaryObject = items
            }
        }
        else {
            print("No items selected.")
            showAlert(alertTitle: "Null entry", alertMessage: "Please select atleast one item.", alertAction: "Ok")
            return
        }
        
        let params: Parameters = jsonToSend.dictionaryObject ?? [:]
        let urlString = "https://9nfmj2dq1f.execute-api.ap-south-1.amazonaws.com/Development/orders/add-order"
        Alamofire.request(urlString, method: .post, parameters: params,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                print(response)
                print("Success")
                self.dismiss(animated: true, completion: {});
                self.navigationController?.popViewController(animated: true);
            case .failure(let error):
                
                print(error)
            }
        }
        
    }
    func makeRoundedViewWithDropShadow(currentView: UIView) {
        // corner radius
        currentView.layer.cornerRadius = 10
        
        currentView.layer.borderWidth = 0.0
        
        // shadow
        currentView.layer.shadowColor = UIColor.black.cgColor
        currentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        currentView.layer.shadowOpacity = 0.2
        currentView.layer.shadowRadius = 4.0
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yy"
        
        dateTextField.text = dateFormatter.string(from:  datePicker.date)
        view.endEditing(true)
    }
    
    func showAlert(alertTitle: String, alertMessage: String, alertAction: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: alertAction, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
