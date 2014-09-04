//
//  FlickrPhotosTVC.swift
//  Shutterbug
//
//  Created by kigi on 8/21/14.
//  Copyright (c) 2014 classroomM. All rights reserved.
//

import UIKit

class FlickrPhotosTVC: UITableViewController {

    var photos: NSArray! {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.photos != nil ? self.photos.count : 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Flickr Photo Cell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        if let photo = self.photos[indexPath.row] as? NSDictionary {
            cell.textLabel?.text = photo.valueForKeyPath(FLICKR_PHOTO_TITLE) as? String
            cell.detailTextLabel?.text = photo.valueForKeyPath(FLICKR_PHOTO_DESCRIPTION) as? String
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
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
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /*
        if let detail = self.splitViewController.viewControllers[1] as? ImageViewController {
            self.prepareImageViewController(detail, toDisplayPhoto: self.photos[indexPath.row] as? NSDictionary)
        }
        */
        println("didSelecRowAtIndexPath")
        if self.splitViewController == nil {
            return
        }
        /* 因為在 SpliterViewController 的 Detail 改接 NavigationController，所以要改判斷 */
        if let detail = self.splitViewController!.viewControllers[1] as? UINavigationController {
            if let view = detail.viewControllers.first as? ImageViewController {
                self.prepareImageViewController(view, toDisplayPhoto: self.photos[indexPath.row] as? NSDictionary)
            }
        }
        

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        println("prepareForSegue")
        if let cell = sender as? UITableViewCell {
            if let indexPath = self.tableView.indexPathForCell(cell) {
                if segue.identifier == "Display Photo" {
                    if let view = segue.destinationViewController as? ImageViewController {
                        self.prepareImageViewController(view, toDisplayPhoto: self.photos[indexPath.row] as? NSDictionary)
                    }
                }
            }
        }
    }

    func prepareImageViewController(view: ImageViewController!, toDisplayPhoto photo: NSDictionary!) {
        view.imageURL = FlickrFetcher.URLforPhoto(photo, format: FlickrPhotoFormat.Large)
        view.title = photo.valueForKeyPath(FLICKR_PHOTO_TITLE) as? String
    }

}
