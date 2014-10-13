//
//  ViewController.swift
//  PhotoFilters
//
//  Created by Reid Weber on 10/13/14.
//  Copyright (c) 2014 com.reidweber. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GalleryProtocol, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	
	@IBOutlet weak var imageView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		var image = UIImage(named: "testPhoto.jpg")
		
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
		let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (action) -> Void in
			let imagePicker = UIImagePickerController()
			imagePicker.allowsEditing = true
			imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
			imagePicker.delegate = self
			self.presentViewController(imagePicker, animated: true, completion: nil)
		}
		alertController.addAction(galleryAction)
		alertController.addAction(cancelAction)
		alertController.addAction(cameraAction)
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
	func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
		self.imageView.image = editingInfo[UIImagePickerControllerEditedImage] as? UIImage
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func perpareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "SHOW_GALLERY") {
			//segue.destinationViewController.
		}
	}
	
	func didTapOnItem(image: UIImage) {
		println("Tap on item called")
		self.imageView.image = image
	}

}

