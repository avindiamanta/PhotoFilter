//
//  AVFoundationCameraViewController.swift
//  CFImageFilterSwift
//
//  Created by Bradley Johnson on 9/22/14.
//  Copyright (c) 2014 Brad Johnson. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia
import CoreVideo
import ImageIO
import QuartzCore

class AVFoundationCameraViewController: UIViewController {
	
	@IBOutlet weak var capturePreviewImageView: UIImageView!
	@IBOutlet weak var acceptPhotoButton: UIButton!
	
	var previewLayerContainerView: UIView!
	var previewTopConstraint: NSLayoutConstraint!
	var previewLeadingConstraint: NSLayoutConstraint!
	
	var delegate: GalleryProtocol?
	
	var stillImageOutput = AVCaptureStillImageOutput()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.acceptPhotoButton.hidden = true
		
		var captureSession = AVCaptureSession()
		captureSession.sessionPreset = AVCaptureSessionPresetPhoto
		var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		previewLayer.frame = CGRectMake(0, 64, self.view.frame.size.width, CGFloat(self.view.frame.size.height * 0.6))
		
		self.view.layer.addSublayer(previewLayer)
		
		
		
/*		Below is the failed attempt to get constraints on the preview layer
		
		
		let kContainerXPosition = (self.view.bounds.origin.x + ((self.view.bounds.width/2) - (previewLayer.bounds.width / 2)))
		let kContainerYPosition = (self.view.bounds.origin.y + ((self.view.bounds.height/2) - (previewLayer.bounds.height / 2)))
		self.previewLayerContainerView = UIView(frame: CGRectMake(kContainerXPosition , kContainerYPosition, previewLayer.bounds.width, previewLayer.bounds.height))
		self.previewTopConstraint = NSLayoutConstraint(item: self.previewLayerContainerView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: kContainerXPosition)
		self.previewLeadingConstraint = NSLayoutConstraint(item: self.previewLayerContainerView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: kContainerYPosition)
		self.previewLayerContainerView.addConstraint(self.previewTopConstraint)
		self.previewLayerContainerView.addConstraint(self.previewLeadingConstraint)
		self.view.addSubview(self.previewLayerContainerView)
*/
		
		var device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
		var error : NSError?
		var input = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error) as! AVCaptureDeviceInput!
		if input == nil {
			println("bad!")
		}
		captureSession.addInput(input)
		var outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
		self.stillImageOutput.outputSettings = outputSettings
		captureSession.addOutput(self.stillImageOutput)
		captureSession.startRunning()
		
		
		// Do any additional setup after loading the view.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	@IBAction func capturePressed(sender: AnyObject) {
		
		var videoConnection : AVCaptureConnection?
		for connection in self.stillImageOutput.connections {
			if let cameraConnection = connection as? AVCaptureConnection {
				for port in cameraConnection.inputPorts {
					if let videoPort = port as? AVCaptureInputPort {
						if videoPort.mediaType == AVMediaTypeVideo {
							videoConnection = cameraConnection
							break;
						}
					}
				}
			}
			if videoConnection != nil {
				break;
			}
		}
		self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(buffer : CMSampleBuffer!, error : NSError!) -> Void in
			var data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
			var image = UIImage(data: data)
			self.capturePreviewImageView.image = image
			println(image!.size)
			self.acceptPhotoButton.hidden = false
		})
		
		
	}
	
	@IBAction func acceptButtonPressed(sender: AnyObject) {
		self.delegate?.didTapOnItem(self.capturePreviewImageView.image!)
		self.dismissViewControllerAnimated(true, completion: nil)
		
	}
}