//
//  CameraController.swift
//  Instragram20170417
//
//  Created by Nathan on 4/26/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import AVFoundation
class CameraController: UIViewController,AVCapturePhotoCaptureDelegate {
    lazy var capturebutton:UIButton = {
       let cpb = UIButton(type: .system)
        cpb.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        cpb.addTarget(self, action: #selector(handlecapture), for: .touchUpInside)
        return cpb
    }()
    lazy var cancelphoto:UIButton = {
        let cpb = UIButton(type: .system)
        cpb.setTitle("Cancel", for: .normal)
        cpb.backgroundColor = UIColor.clear
        cpb.setTitleColor(.white, for: .normal)
        cpb.addTarget(self, action: #selector(dismisscapture), for: .touchUpInside)
        return cpb
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupcamera()
        view.addSubview(capturebutton)
        capturebutton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        capturebutton.anchor(top: nil, left: nil, right: nil, bottom: view.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: -20, width: 80, height: 80)
        view.addSubview(cancelphoto)
        cancelphoto.anchor(top: view.topAnchor, left: view.leftAnchor, right: nil, bottom: nil, paddingTop: 8, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
    }
    func handlecapture(){
        let setting = AVCapturePhotoSettings()
        guard let previewformattype = setting.availablePreviewPhotoPixelFormatTypes.first else {return}
        setting.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String:previewformattype]
        output.capturePhoto(with: setting, delegate: self)
    }
    let output = AVCapturePhotoOutput()
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        let imagedata = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!)
        let image = UIImage(data: imagedata!)
        let previewimageview = CameraContainer()
        previewimageview.previewimageview.image = image
        view.addSubview(previewimageview)
        previewimageview.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
       
        
        print("Finish Processing Image")
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }
    func setupcamera(){
        let captureSession = AVCaptureSession()
        let capturedevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do{
        let input = try AVCaptureDeviceInput(device: capturedevice)
            if captureSession.canAddInput(input)
            {
             captureSession.addInput(input)
            }
            if captureSession.canAddOutput(output){
                captureSession.addOutput(output)
            }
            guard let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) else {return}
            previewLayer.frame = self.view.frame
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            view.layer.addSublayer(previewLayer)
            captureSession.startRunning()
        }
        catch{
            
        }
        
        
        
        
    }
    func dismisscapture(){
        self.dismiss(animated: true, completion: nil)
    }

}
