//
//  OrderDetailsViewController.swift
//  Bootcamp
//
//  Created by justin monsi on 11/16/18.
//  Copyright © 2018 IODevelopers. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderDetailsViewController: UIViewController {
    
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var itemsView: UIView!
    @IBOutlet weak var admissionNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    var currentOrderDetails: JSON = [:]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        makeRoundedViewWithDropShadow(currentView: mainContainerView)
        makeRoundedViewWithDropShadow(currentView: itemsView)
        
        let jsonString = UserDefaults.standard.string(forKey: "CurrentOrder")
        currentOrderDetails = JSON.init(parseJSON: jsonString!)
        
        setOrderDetails()
    }
    
    func setOrderDetails() {
        print("Order Details: \(String(describing: self.currentOrderDetails))")
        let admissionText: String = "Admission Number: "+self.currentOrderDetails["IDNo"].stringValue
        let dateText: String = "Date: " + self.currentOrderDetails["OrderDate"].stringValue
        self.admissionNumberLabel.text = admissionText
        self.dateLabel.text = dateText
        let items = self.currentOrderDetails["OrderedItems"].dictionaryValue
        var totalValue: Float = 0.0
        var currentLabelYPosition : CGFloat = 0
        for key in items.keys {
            totalValue = totalValue + (items[key]?.floatValue)!
            let itemText = key+" * 1 = "+(items[key]?.stringValue)!
            createItemLabel(labeltext: itemText, labelYPosition: currentLabelYPosition)
            currentLabelYPosition = currentLabelYPosition + 40
        }
        let totalText: String = "Total: " + String(totalValue)
        self.totalLabel.text = totalText
    }
    
    func makeRoundedViewWithDropShadow(currentView: UIView) {
        // corner radius
        currentView.layer.cornerRadius = 10
        
        // shadow
        currentView.layer.shadowColor = UIColor.black.cgColor
        currentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        currentView.layer.shadowOpacity = 0.5
        currentView.layer.shadowRadius = 2.0
    }
    
    func createItemLabel(labeltext: String, labelYPosition: CGFloat) {
        let label = UILabel()
        label.text = labeltext
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25.0)
        label.frame.origin.y = labelYPosition
        label.frame.size.width = 316
        label.frame.size.height = 29
        itemsView.addSubview(label)
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
