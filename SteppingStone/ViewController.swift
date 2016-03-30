//
//  ViewController.swift
//  SteppingStone
//
//  Created by Jeff Chimney on 2016-02-28.
//  Copyright © 2016 Jeff Chimney. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet var tableView: UITableView!
    
    let categories = ["School", "Home"]
    let textCellIdentifier = "TextCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    ///////////////////////////// Table View Data Source Methods \\\\\\\\\\\\\\\\\\\\\
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = categories[row]
        
        return cell
    }

    ///////////////////////////// Table View Delegate Methods \\\\\\\\\\\\\\\\\\\\\
    
    // called when user taps on row in tableview
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //let row = indexPath.row
        //print(categories[row])
    }
    
    let blogSegueIdentifier = "ShowCategorySegue"
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == blogSegueIdentifier {
            if let destination = segue.destinationViewController as? CategoryViewController {
                if let categoryIndex = tableView.indexPathForSelectedRow?.row {
                    destination.categoryName = categories[categoryIndex]
                }
            }
        }
    }
}

