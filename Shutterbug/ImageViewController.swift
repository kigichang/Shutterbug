//
//  ImageViewController.swift
//  Imaginarium
//
//  Created by kigi on 8/19/14.
//  Copyright (c) 2014 classroomM. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate, UISplitViewControllerDelegate {
    
// MARK: Properties
    @IBOutlet var scrollView: UIScrollView! {
        didSet {
            self.scrollView.contentSize = self.imageView.image != nil ? self.imageView.image!.size : CGSizeZero
            
            self.scrollView.minimumZoomScale = CGFloat(0.2)
            self.scrollView.maximumZoomScale = CGFloat(2.0)
            
            self.scrollView.delegate = self
        }
    }
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    
    var imageURL: NSURL? {
        didSet {
            //self.image = UIImage(data: NSData.dataWithContentsOfURL(self.imageURL!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil))
            self.startDownloadingImage()
        }
    }
    
    lazy var imageView = UIImageView()
    
    var image: UIImage! {
        get {
            return self.imageView.image
        }
        
        set {
            if self.scrollView != nil {
                self.scrollView.zoomScale = CGFloat(1.0)
            }
            self.imageView.image = newValue
            if newValue != nil {
                self.imageView.frame = CGRectMake(CGFloat(0.0), CGFloat(0.0), newValue.size.width, newValue.size.height)
            }
            //self.imageView.frame = CGRectMake(CGFloat(0.0), CGFloat(0.0), image.size.width, newValue.size.height)
            //self.imageView.sizeToFit()
            if self.spinner != nil {
                self.spinner.stopAnimating()
            }
            
            if self.scrollView != nil && self.imageView.image != nil {
                self.scrollView.contentSize = self.imageView.image!.size
            }
            else if self.scrollView != nil {
                self.scrollView.contentSize = CGSizeZero
            }
        }
    }

    func startDownloadingImage() {
        self.image = nil
        
        if let url = self.imageURL {
            if self.spinner != nil {
                self.spinner.startAnimating()
            }
            
            let request = NSURLRequest(URL: url)
            let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
            let session = NSURLSession(configuration: config)
            
            let task = session.downloadTaskWithRequest(request, completionHandler: {
                (localfile: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
                if error == nil {
                    if request.URL == url {
                        let img = UIImage(data: NSData.dataWithContentsOfURL(localfile, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil))
                        
                        dispatch_async(dispatch_get_main_queue(), { self.image = img })
                    }
                }
                
            })
            
            task.resume()
        }
        
    }
    
    
// MARK: Initialize
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.addSubview(imageView)
    }
    
// MARK: ScrollDelegate
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return self.imageView
    }
    
// MARK: Spilter Delegate
    override func awakeFromNib() {
        //if self.splitViewController != nil {
        //    self.splitViewController.delegate = self
        //}
        
        self.splitViewController?.delegate = self
    }
    
    //func splitViewController(svc: UISplitViewController!, shouldHideViewController vc: UIViewController!, inOrientation orientation: UIInterfaceOrientation) -> Bool {
        
    //    return UIInterfaceOrientationIsPortrait(orientation)
    //}
    
    func splitViewController(svc: UISplitViewController!, willHideViewController aViewController: UIViewController!, withBarButtonItem barButtonItem: UIBarButtonItem!, forPopoverController pc: UIPopoverController!) {

        barButtonItem.title = aViewController.title
        self.navigationItem.leftBarButtonItem = barButtonItem
    }
    
    func splitViewController(svc: UISplitViewController!, willShowViewController aViewController: UIViewController!, invalidatingBarButtonItem barButtonItem: UIBarButtonItem!) {
        self.navigationItem.leftBarButtonItem = nil
    }
    
    
}
