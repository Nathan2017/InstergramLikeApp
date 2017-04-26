//
//  CameraController.swift
//  Instragram20170417
//
//  Created by Nathan on 4/26/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import AVFoundation
class CameraController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupcamera()
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
        }
        catch{
            
        }
        if #available(iOS 10.0, *) {
            let output = AVCapturePhotoOutput()
            if captureSession.canAddOutput(output)
            {
                captureSession.addOutput(output)
            }
        } else {
            // Fallback on earlier versions
        }
        guard let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) else {return}
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
        
    }

}
