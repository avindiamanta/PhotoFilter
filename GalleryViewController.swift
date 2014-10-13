//
//  GalleryViewController.swift
//  PhotoFilters
//
//  Created by Reid Weber on 10/13/14.
//  Copyright (c) 2014 com.reidweber. All rights reserved.
//

import UIKit

protocol GalleryProtocol {
	func didTapOnItem(image: UIImage)
}

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

	@IBOutlet weak var collectionView: UICollectionView!
	
	var images = [UIImage]()
	var delegate: GalleryProtocol?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
//		let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//		
//		let collectionViewLayout = UICollectionViewLayout()
//		collectionViewLayout.collectionView?.bounds = CGRectMake(0, 0, appDelegate.window!.frame.width, appDelegate.window!.frame.height)
//		self.collectionView.collectionViewLayout = UICollectionViewLayout()
		
		self.collectionView.dataSource = self
		self.collectionView.delegate = self
		
		var image1 = UIImage(named: "photo1.jpg")
		var image2 = UIImage(named: "photo2.jpg")
		var image3 = UIImage(named: "photo3.jpg")
		
		self.images.append(image1)
		self.images.append(image2)
		self.images.append(image3)
		
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.images.count
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("GALLERY_CELL", forIndexPath: indexPath) as CollectionViewCell
		cell.imageView.image = self.images[indexPath.row]
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		println("Count: \(self.images.count)")
		self.delegate?.didTapOnItem(self.images[indexPath.row])
		self.dismissViewControllerAnimated(true, completion: nil)
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
