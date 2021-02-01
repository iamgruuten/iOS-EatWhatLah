//
//  CustomCameraController.swift
//  EatWhatLah
//
//  Created by Apple on 1/2/21.
//

import Foundation
import AVFoundation
import UIKit

class CustomCameraController:UIViewController{
    
    let captureSession = AVCaptureSession()
    var backFacingCamera: AVCaptureDevice?
    var frontFacingCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice!
    
    var stillImageOutput: AVCapturePhotoOutput!
    var stillImage: UIImage?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    @IBOutlet var galleryView: UIButton?

    
    @IBOutlet var topViewBlur: UIView!
    
    @IBOutlet var bottomViewBlur: UIView!
    
    
    @IBOutlet var cameraButton:UIButton!
  
  override func viewDidLoad() {
      super.viewDidLoad()
        configure()
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
    
    // MARK: - Action methods

    @IBAction func capture(sender: UIButton) {
            // Set photo settings
            let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            photoSettings.isHighResolutionPhotoEnabled = true
            photoSettings.flashMode = .auto
             
            stillImageOutput.isHighResolutionCaptureEnabled = true
            stillImageOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    
    @IBAction func unwindToCameraView(segue: UIStoryboardSegue) {
    
    }
    
    private func configure() {
        // Get the front and back-facing camera for taking photos
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .unspecified)
        
        for device in deviceDiscoverySession.devices {
            if device.position == .back {
                backFacingCamera = device
            } else if device.position == .front {
                frontFacingCamera = device
            }
        }
        
        currentDevice = backFacingCamera
        
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: currentDevice) else {
            return
        }
        
        stillImageOutput = AVCapturePhotoOutput()
        captureSession.addInput(captureDeviceInput)
        captureSession.addOutput(stillImageOutput)
        
        // Provide a camera preview
                cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                view.layer.addSublayer(cameraPreviewLayer!)
                cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                cameraPreviewLayer?.frame = view.layer.frame
                 
        // Bring the camera button to front
                view.bringSubviewToFront(topViewBlur)
                view.bringSubviewToFront(bottomViewBlur)
                view.bringSubviewToFront(cameraButton)
        view.bringSubviewToFront(galleryView!)

                captureSession.startRunning()
    }
    
}

extension CustomCameraController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            return
        }
         
        // Get the image from the photo buffer
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
         
        stillImage = UIImage(data: imageData)
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let photoViewController = mainStoryboard.instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoViewController
        photoViewController.image = stillImage
        photoViewController.modalPresentationStyle = .fullScreen
        self.present(photoViewController, animated: true)
        
    }
}


