//
//  ViewOrdersViewController.swift
//  Bootcamp
//
//  Created by Rajat Jaic Mendus on 11/12/18.
//  Copyright © 2018 IODevelopers. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewOrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    // Data model: These strings will be the data for the table view cells
    var orderJSON: JSON = [:]
    var orders: [String] = []
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    
    // don't forget to hook this up from the storyboard
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the orders from web
        self.getOrders()
        
        // Register the table view cell class and its reuse id
//        self.tableView.register(OrdersCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
         self.tableView.tableFooterView = UIView()
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getOrders() {
        let url = Constants.viewOrderAPI
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.orderJSON = json
                print("JSON: \(json)")
                self.orders = json["Menu_ITEMS"].arrayValue.map({$0["OrderDate"].stringValue})
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell: OrdersCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! OrdersCell
        
        // set the text from the data model
        cell.datelabel.text = self.orders[indexPath.row]
        
        cell.cellContainerView.layer.shadowColor = UIColor.black.cgColor
        cell.cellContainerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.cellContainerView.layer.shadowOpacity = 0.2
        cell.cellContainerView.layer.shadowRadius = 4.0
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        let selectedOrder = orderJSON["Menu_ITEMS"].arrayValue[indexPath.row]
        print(selectedOrder)
        let jsonString = selectedOrder.rawString()
        UserDefaults.standard.set(jsonString, forKey: "CurrentOrder")
        
        self.performSegue(withIdentifier: "viewOrderSegue", sender: self)
    }
}
