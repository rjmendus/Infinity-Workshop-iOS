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
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
         self.tableView.tableFooterView = UIView()
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getOrders() {
        let url = "https://9nfmj2dq1f.execute-api.ap-south-1.amazonaws.com/Development/orders/get-all"
        
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                self.orders = json["Menu_ITEMS"].arrayValue.map({$0["OrderDate"].stringValue})
                print(self.orders)
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
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        
        // set the text from the data model
        cell.textLabel?.text = self.orders[indexPath.row]
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }

}
