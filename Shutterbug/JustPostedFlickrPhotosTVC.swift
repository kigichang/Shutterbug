//
//  JustPostedFlickrPhotosTVC.swift
//  Shutterbug
//
//  Created by kigi on 8/21/14.
//  Copyright (c) 2014 classroomM. All rights reserved.
//

import UIKit

class JustPostedFlickrPhotosTVC: FlickrPhotosTVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.fetchPhotos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchPhotos() {
        // use non-blocking call
        let queue = dispatch_queue_create("flickr fetcher", nil)
        // xcode6 不用 將 Refresh Control 綁定 Action。直接 beginRefreshing and endRefreshing
        //if self.refreshControl != nil {
        //    self.refreshControl?.beginRefreshing()
        //}
        self.refreshControl?.beginRefreshing()
        
        dispatch_async(queue, {
            let url = FlickrFetcher.URLforRecentGeoreferencedPhotos()
            let jsonResults = NSData(contentsOfURL: url)
            let propertyListResults = NSJSONSerialization.JSONObjectWithData(jsonResults, options: NSJSONReadingOptions.allZeros, error: nil) as? NSDictionary
            
            let photos = propertyListResults?.valueForKeyPath(FLICKR_RESULTS_PHOTOS) as? NSArray
            
            dispatch_async(dispatch_get_main_queue(), {
                //if self.refreshControl != nil {
                //    self.refreshControl?.endRefreshing()
                //}
                self.refreshControl?.endRefreshing()
                self.photos = photos
            })
        })
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
