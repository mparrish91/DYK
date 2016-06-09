//
//  FavouritesViewController.swift
//  DYK
//
//  Created by Navarjun Singh on 2/26/16.
//  Copyright © 2016 PINC. All rights reserved.
//

import UIKit

class FavouritesViewController: UITableViewController, SuperViewController {

    static var identifier = "favouritesViewController"
    
    private lazy var noFactsLabel: UILabel = {
            let label = UILabel(frame: CGRect(x: self.view.frame.width/2 - 280/2, y: self.view.frame.width/2, width: 280, height: 100))
            label.numberOfLines = 0
            label.textAlignment = .Center
            label.font = UIFont.systemFontOfSize(18)
            label.textColor = signatureColor(0.5)
            label.text = "You haven't liked any facts yet. Give facts a 'Thumbs Up' to like."
            return label
        }()
    
    var factsArray: Array<DYKFact>! {
        didSet {
            tableView.reloadData()
            if factsArray.count == 0 && noFactsLabel.superview == nil {
                self.view.addSubview(noFactsLabel)
            } else if factsArray.count != 0 && noFactsLabel.superview != nil {
                noFactsLabel.removeFromSuperview()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "dismiss")
        
        title = "Favorites"
        let logo = UIImage(named: "favorite")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        self.navigationItem.title = "Favorites" 
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        NetworkingHelper.sharedInstance.getFavourites({ (facts) -> Void in
            self.factsArray = facts
        }) { (error) -> Void in
            ErrorsHelper.sharedInstance.notifyError(error, overViewController: self)
        }
    }

    func dismiss() {
        navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let fact = factsArray[indexPath.row]
        let attrs = [NSFontAttributeName: UIFont.systemFontOfSize(17)]
        
        let labelSize = fact.factContent.boundingRectWithSize( CGSizeMake(tableView.frame.width-20, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes:attrs, context:nil).size
        return labelSize.height+30
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if factsArray != nil {
            return factsArray.count
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("favouritesTableCell", forIndexPath: indexPath)

        // Configure the cell...
        let label = cell.viewWithTag(1) as! UILabel
        label.text = factsArray[indexPath.row].factContent

        cell.layoutIfNeeded()
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
