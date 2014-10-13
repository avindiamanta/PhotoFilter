//
//  ViewController.swift
//  PhotoFilters
//
//  Created by Reid Weber on 10/13/14.
//  Copyright (c) 2014 com.reidweber. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func photosButtonPressed(sender: AnyObject) {
		
		let alertController = UIAlertController(title: nil, message: "Choose an Option", preferredStyle: UIAlertControllerStyle.ActionSheet)
		let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) { (action) -> Void in
			self.performSegueWithIdentifier("SHOW_GALLERY", sender: self)
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
			// don't need the dismiss since the cancel style does it automatically
			// self.dismissViewControllerAnimated(true, completion: nil)
		}
		alertController.addAction(galleryAction)
		alertController.addAction(cancelAction)
		self.presentViewController(alertController, animated: true, completion: nil)
	}

}

