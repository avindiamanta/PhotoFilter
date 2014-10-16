//
//  FilterMainImage.swift
//  PhotoFilters
//
//  Created by Reid Weber on 10/16/14.
//  Copyright (c) 2014 com.reidweber. All rights reserved.
//

import Foundation
import UIKit

class FilteredMainImage {
	
	var originalImage: UIImage
	var filteredImage: UIImage?
	var imageQueue: NSOperationQueue?
	var gpuContext: CIContext
	var filter: CIFilter?
	var filterName: String
	var homeViewController: ViewController
	
	init(name: String, original: UIImage, queue: NSOperationQueue, context: CIContext, homeVC: ViewController) {
		self.filterName = name
		self.originalImage = original
		self.imageQueue = queue
		self.gpuContext = context
		self.homeViewController = homeVC
	}
	
	func generateImage (completionHandeler: (image: UIImage) -> Void) {
		
		self.imageQueue?.addOperationWithBlock({ () -> Void in
			// Setting up the filter with a CIImage
			var image = CIImage(image: self.originalImage)
			var imageFilter = CIFilter(name: self.filterName)
			imageFilter.setDefaults()
			imageFilter.setValue(image, forKey: kCIInputImageKey)
			
			//Generate results
			var result = imageFilter.valueForKey(kCIOutputImageKey) as CIImage
			var extent = result.extent()
			var imageRef = self.gpuContext.createCGImage(result, fromRect: extent)
			self.filter = imageFilter
			self.filteredImage = UIImage(CGImage: imageRef)
			
			UIGraphicsBeginImageContext(self.homeViewController.imageView.image!.size)
			self.filteredImage!.drawInRect(CGRect(origin: self.homeViewController.imageView.bounds.origin, size: self.homeViewController.imageView.image!.size))
			var largeImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			
			NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
				completionHandeler(image: self.filteredImage!)
			})
			
		})
	}
	
}