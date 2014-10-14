//
//  ViewController.swift
//  PhotoFilters
//
//  Created by Reid Weber on 10/13/14.
//  Copyright (c) 2014 com.reidweber. All rights reserved.
//

import UIKit
import CoreImage
import CoreData
import OpenGLES

class ViewController: UIViewController, GalleryProtocol, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDataSource {
	
	@IBOutlet weak var imageViewtrailingConstraint: NSLayoutConstraint!
	@IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
	@IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var filterCollectionBottomConstraint: NSLayoutConstraint!
	
	
	var context: CIContext?
	
	@IBOutlet weak var filterCollectionView: UICollectionView!
	
	var originalThumbnail: UIImage?

	var filters = [Filter]?()
	
	@IBOutlet weak var imageView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		var image = UIImage(named: "testPhoto.jpg")
		
		self.filterCollectionView.dataSource = self
		
		// Setting up core image context
		var options = [kCIContextWorkingColorSpace : NSNull()]
		var myEAGLContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
		self.context = CIContext(EAGLContext: myEAGLContext, options: options)
		
		var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		var seeder = CoreDataSeeder(context: appDelegate.managedObjectContext!)
		
		seeder.seedCoreData()
		self.filters = fetchFilters()
		
		self.generateThumbnail()
		
		
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	func generateThumbnail() {
			let size = CGSize(width: 100, height: 100)
			UIGraphicsBeginImageContext(size)
			self.imageView.image?.drawInRect(CGRectMake(0, 0, 100, 100))
			self.originalThumbnail = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
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
		let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (action) -> Void in
			let imagePicker = UIImagePickerController()
			imagePicker.allowsEditing = true
			imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
			imagePicker.delegate = self
			self.presentViewController(imagePicker, animated: true, completion: nil)
		}
		let filterAction = UIAlertAction(title: "Filters", style: UIAlertActionStyle.Default) { (action) -> Void in
			self.enterFilterMode()
		}
		alertController.addAction(galleryAction)
		alertController.addAction(cancelAction)
		alertController.addAction(cameraAction)
		alertController.addAction(filterAction)
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
		self.imageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "SHOW_GALLERY") {
			let destinationVC = segue.destinationViewController as GalleryViewController
			destinationVC.delegate = self
		}
	}
	
	func didTapOnItem(image: UIImage) {
		println("Tap on item called")
		self.imageView.image = image
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 5
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = self.filterCollectionView.dequeueReusableCellWithReuseIdentifier("FILTER_CELL", forIndexPath: indexPath) as FilterCollectionViewCell
		//cell.filterImageView.image =
		return cell
	}
	
	func fetchFilters() -> [Filter]? {
		var fetchRequest = NSFetchRequest(entityName: "Filter")
		var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		var context = appDelegate.managedObjectContext
		
		var error: NSError?
		let fetchResults = context?.executeFetchRequest(fetchRequest, error: &error)
		
		if let filters = fetchResults as? [Filter] {
			return filters
		} else {
			return nil
		}
	}
	
	func resetFilterThumbnails () {
		var newFilters = [FilterThumbnail]()
		for var index = 0; index < self.filters!.count; index++ {
			var filter = self.filters![index]
			//var filterName =
			//var thumbnail = FilterThumbnail(name: <#String#>, thumbNail: <#UIImage#>, queue: <#NSOperationQueue#>, context: <#CIContext#>)
		}
	}
	
	func enterFilterMode() {
		self.imageViewtrailingConstraint.constant = self.imageViewtrailingConstraint.constant * 3
		self.imageViewLeadingConstraint.constant = self.imageViewLeadingConstraint.constant * 3
		self.imageViewBottomConstraint.constant = self.imageViewBottomConstraint.constant * 3
		self.filterCollectionBottomConstraint.constant = 10
		UIView.animateWithDuration(0.4, animations: { () -> Void in
			self.view.layoutIfNeeded()
		})
	}

}

