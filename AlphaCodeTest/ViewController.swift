//
//  ViewController.swift
//  AlphaCodeTest
//
//  Created by 예재문 on 2023/05/24.
//

import UIKit
import AVFoundation
import MLKitBarcodeScanning
import MLKitVision
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var capButton: UIButton!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var thumbView: UIImageView!
    
    var captureSession: AVCaptureSession!
    
    var cameraBack: AVCaptureDevice!
    var cameraFront: AVCaptureDevice!
    
    var inputBack: AVCaptureInput!
    var inputFront: AVCaptureInput!
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    var videoOutput: AVCaptureVideoDataOutput!
    var capturePhotoOutput: AVCapturePhotoOutput!
    
    var takePicture = false
    var onBackCamera = true
   
    
    func setup_and_start_capture_session() {
        DispatchQueue.global(qos: .userInitiated).async{
            self.captureSession = AVCaptureSession()
            self.captureSession.beginConfiguration()
            
            if self.captureSession.canSetSessionPreset(.photo) {
                self.captureSession.sessionPreset = .photo
            }
            self.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
            
            self.setup_inputs()
            
            DispatchQueue.main.async {
                self.setup_preview_layer()
            }
            
            self.setup_output()
            
            self.captureSession.commitConfiguration()
            self.captureSession.startRunning()
        }
    }
    
    func setup_inputs() {
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            cameraBack = device
        } else {
            fatalError("No video device found. Back")
        }
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            cameraFront = device
        } else {
            fatalError("No video device found. Front")
        }
        
        guard let bi = try? AVCaptureDeviceInput(device: cameraBack) else {
            fatalError("Could not create input device from back camera")
        }
        inputBack = bi
        if !captureSession.canAddInput(inputBack){
            fatalError("Could not add back camera input to capture session")
        }
        
        guard let fi = try? AVCaptureDeviceInput(device: cameraFront) else {
            fatalError("Could not create input device from front camera")
        }
        inputFront = fi
        if !captureSession.canAddInput(inputFront) {
            fatalError("Could not add front camera input to capture session")
        }
        
        captureSession.addInput(inputBack)
            
    }
    
    func setup_preview_layer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.frame = previewView.bounds
        previewView.layer.addSublayer(previewLayer!)
    }
    
    func setup_output() {
        videoOutput = AVCaptureVideoDataOutput()
        let videoQueue = DispatchQueue(label: "videoQueue", qos: .userInteractive)
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        if captureSession.canAddOutput(videoOutput){
            captureSession.addOutput(videoOutput)
        } else {
            fatalError("could not add video output")
        }
        videoOutput.connections.first?.videoOrientation = .portrait
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setup_and_start_capture_session()
    }

    @IBAction func segControlChanged(_ sender: UISegmentedControl) {

        captureSession.beginConfiguration()
        if(sender.selectedSegmentIndex == 1){
//          print("Front")
          captureSession.removeInput(inputBack)
          captureSession.addInput(inputFront)
            onBackCamera = false
        } else {
//          print("Rear")
          captureSession.removeInput(inputFront)
          captureSession.addInput(inputBack)
            onBackCamera = true
        }
        
        captureSession.commitConfiguration()
                
      }

    @IBAction func captureButtonClicked(_ sender: UIButton) {
        takePicture = true
    }
    
    
    func detect_barcodes(image: UIImage?) {
        guard let image = image else {
            print("not image, return")
            return
            
        }

        let format = BarcodeFormat.qrCode
        let barcodeOptions = BarcodeScannerOptions(formats: format)
        
        let barcodeScanner = BarcodeScanner.barcodeScanner(options: barcodeOptions)
        
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        
        barcodeScanner.process(visionImage) { features, error in
            guard error == nil else {
//                print("error is nil")
                return
            }
            guard let features = features, !features.isEmpty else {
//                print("features is empty")
                return
            }
            features.forEach { feature in
                if let url = URL(string: feature.rawValue!) {
                    if UIApplication.shared.canOpenURL(url){
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        return
                    }
                }
            }
        }
        //
        
    }
}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        print("Capture OUTPUT")
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            fatalError("making cgImage failed.")
        }
        
        let uiImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: onBackCamera == true ? .up : .leftMirrored)
//        print("make uiimage and detect")
        self.detect_barcodes(image: uiImage)

        if !takePicture {
            return //we have nothing to do with the image buffer
        }
        
        DispatchQueue.main.async {
            self.thumbView.image = uiImage
            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
            self.takePicture = false
        }
    }
}
