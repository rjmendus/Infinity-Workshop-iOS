//  LoginViewController.swift
//  Bootcamp
//
//  Created by Rajat Jaic Mendus on 11/2/18.
//  Copyright © 2018 IODevelopers. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet weak var LoginContainer: UIView!
    @IBOutlet weak var admissionTextField: UITextField!
    @IBAction func submitLoginButton(_ sender: Any) {
        
        print("Login Pressed")
        guard let admissionNumber = admissionTextField.text, !admissionNumber.isEmpty else {
            showAlert(alertTitle: "Null entry", alertMessage: "Please enter your admission number", alertAction: "Ok")
            return
        }
        checkForValidUser(userAdmissionNumber: admissionNumber)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setContainerShadowAndRoundedEdges(container: LoginContainer)
        admissionTextField.borderStyle = UITextField.BorderStyle.none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    func setContainerShadowAndRoundedEdges(container: UIView) {
        // Set rounded corners at top right and bottom right
        let path = UIBezierPath(roundedRect:container.bounds,
                                byRoundingCorners:[.topRight, .bottomRight],
                                cornerRadii: CGSize(width: 20, height:  20))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        container.layer.mask = maskLayer
        // Set container shadow
        container.layer.masksToBounds = false
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        container.layer.shadowRadius = 4.0
        container.layer.shadowOpacity = 0.7
        
    }
    
    func checkForValidUser(userAdmissionNumber: String) {
        let parameters: Parameters = ["Idno": userAdmissionNumber]
        let url  = Constants.loginAPI
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("LoginAPIJSON: \(json)")
                if (json["statusCode"] == 200) {
                    print("Login Successfull")
                    UserDefaults.standard.set(userAdmissionNumber, forKey: "UserAdmissionNumber")
                    self.performSegue(withIdentifier: "loginToHomeSegue", sender: self)
                }
                else {
                    print("Invalid credentials")
                    self.showAlert(alertTitle: "Invalid credentials", alertMessage: "Invalid admission number", alertAction: "Ok")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func showAlert(alertTitle: String, alertMessage: String, alertAction: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: alertAction, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
