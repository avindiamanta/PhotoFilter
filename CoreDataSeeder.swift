//
//  CoreDataSeeder.swift
//  PhotoFilters
//
//  Created by Reid Weber on 10/14/14.
//  Copyright (c) 2014 com.reidweber. All rights reserved.
//

import Foundation
import CoreData

class CoreDataSeeder {
	var managedObjectContext: NSManagedObjectContext!
	
	init (context: NSManagedObjectContext) {
		self.managedObjectContext = context
	}
	
	func seedCoreData() {
		var sepia = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
		sepia.name = "CISepiaTone"
		
		var gaussianBlur = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
		gaussianBlur.name = "CIGaussianBlur"
		gaussianBlur.favorited = true
		
		var pixellate = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
		pixellate.name = "CIPixellate"
		
		var photoEffectChrome = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
		photoEffectChrome.name = "CIPhotoEffectChrome"
		
		var photoEffectMono = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
		photoEffectMono.name = "CIPhotoEffectMono"
		
		var photoEffectNoir = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
		photoEffectNoir.name = "CIPhotoEffectNoir"
		
		var error: NSError?
		self.managedObjectContext.save(&error)
		
		if error != nil {
			println(error?.localizedDescription)
		}
	}
	
}
