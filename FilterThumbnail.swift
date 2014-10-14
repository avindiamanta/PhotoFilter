//
//  FilterThumbnail.swift
//  PhotoFilters
//
//  Created by Reid Weber on 10/14/14.
//  Copyright (c) 2014 com.reidweber. All rights reserved.
//

import Foundation
import UIKit

class FilterThumbnail {
	
	var originalThumbnail: UIImage
	var filteredThumbnail: UIImage?
	var imageQueue: NSOperationQueue?
	var gpuContext: CIContext
	var filter: CIFilter?
	var filterName: String
	
	init(name: String, thumbNail: UIImage, queue: NSOperationQueue, context: CIContext) {
		self.filterName = name
		self.originalThumbnail = thumbNail
		self.imageQueue = queue
		self.gpuContext = context
	}
	
	func generateThumbnail (completionHandeler: (image: UIImage) -> Void) {
		
		self.imageQueue?.addOperationWithBlock({ () -> Void in
			// Setting up the filter with a CIImage
			var image = CIImage(image: self.originalThumbnail)
			var imageFilter = CIFilter(name: self.filterName)
			imageFilter.setDefaults()
			imageFilter.setValue(image, forKey: kCIInputImageKey)
			
			//Generate results
			var result = imageFilter.valueForKey(kCIOutputImageKey) as CIImage
			var extent = result.extent()
			var imageRef = self.gpuContext.createCGImage(result, fromRect: extent)
			self.filter = imageFilter
			self.filteredThumbnail = UIImage(CGImage: imageRef)
			
			NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
				completionHandeler(image: self.filteredThumbnail!)
			})

		})
	}
}