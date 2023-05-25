////
////  ViewController.swift
////  AlphaCodeTest
////
////  Created by 예재문 on 2023/05/24.
////
//
//import UIKit
//import AVFoundation
//
//
//class ViewController1: UIViewController {
//    
//    @IBOutlet weak var segControl: UISegmentedControl!
//    @IBOutlet weak var capButton: UIButton!
//    @IBOutlet weak var previewView: UIView!
//    @IBOutlet weak var thumbView: UIImageView!
//    
//    var captureSession: AVCaptureSession?
//    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
//    var capturePhotoOutput: AVCapturePhotoOutput?
//    
//    
//        
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        videoPreviewLayer!.frame = previewView.bounds
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
////        capButton.layer.codrnerRadius = capButton.frame.size.width / 2
////        capButton.clipsToBounds = true
//        // get an instance of the acvapturedevice class to initialize a device object and provide the video as the media type parameter
////        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
//        guard let captureDeviceBack = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
//            fatalError("No video device found. Back")
//        }
//        guard let captureDeviceFront = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
//            fatalError("No Video Device Found. Front")
//        }
//        //        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
//        //                                                  for: .video, position: .back)
//        
//        do {
//            // Get an instance of the AVCaptureDeviceInput class using the previous deivce object
//            let input_back = try AVCaptureDeviceInput(device: captureDeviceBack)
//            let input_front = try AVCaptureDeviceInput(device: captureDeviceFront)
//            
//            // Initialize the captureSession object
//            captureSession = AVCaptureSession()
//            
//            // Set the input devcie on the capture session
//            captureSession?.addInput(input_back)
//            
//            // Get an instance of ACCapturePhotoOutput class
//            capturePhotoOutput = AVCapturePhotoOutput()
////            capturePhotoOutput?.maxPhotoDimensions
////            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
//            
//            // Set the output on the capture session
//            captureSession?.addOutput(capturePhotoOutput!)
//            
//            
//            //Initialise the video preview layer and add it as a sublayer to the viewPreview view's layer
//            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
//            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
////            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resize
//            videoPreviewLayer?.frame = view.layer.bounds
////            previewView.layer.addSublayer(videoPreviewLayer!)
//            previewView.layer.addSublayer(videoPreviewLayer!)
//            
//            //start video capture
//            captureSession?.startRunning()
//            
//        } catch {
//            //If any error occurs, simply print it out
//            print(error)
//            return
//        }
////        captureSession?.beginConfiguration()
////        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
////                                                  for: .video, position: .back)
//        
//        
//    }
//        
//
//    @IBAction func segControlChanged(_ sender: UISegmentedControl) {
//        captureSession?.stopRunning()
//
//        guard let captureDeviceBack = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
//            fatalError("No video device found. Back")
//        }
//        guard let captureDeviceFront = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
//            fatalError("No Video Device Found. Front")
//        }
//        //        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
//        //                                                  for: .video, position: .back)
//        
//        do {
//            // Get an instance of the AVCaptureDeviceInput class using the previous deivce object
//            let input_back = try AVCaptureDeviceInput(device: captureDeviceBack)
//            let input_front = try AVCaptureDeviceInput(device: captureDeviceFront)
//            captureSession?.beginConfiguration()
//            if(sender.selectedSegmentIndex == 0){
//                print("Rear")
//                captureSession?.removeInput(input_back)
//                captureSession?.addInput(input_front)
//                
//            } else {
//                print("Front")
//                captureSession?.removeInput(input_front)
//                captureSession?.addInput(input_back)
//            }
//            captureSession?.commitConfiguration()
//        } catch {
//            //If any error occurs, simply print it out
//            print(error)
//            return
//        }
//    }
//    
//    @IBAction func captureButtonClicked(_ sender: UIButton) {
//        print(segControl.selectedSegmentIndex)
//        // Make sure capturePhotoOutput is valid
//        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
//        
//        // Get an instance of AVCapturePhotoSettings class
//        let photoSettings = AVCapturePhotoSettings()
//        
//        // Set photo settings for our need
////        photoSettings.isAutoStillImageStabilizationEnabled = true
////        photoSettings.isHighResolutionPhotoEnabled = true
//        photoSettings.flashMode = .auto
//        
//        // Call capturePhoto method by passing our photo settings and a delegate implementing AVCapturePhotoCaptureDelegate
//        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
//    }
//    
//}
//
//extension ViewController : AVCapturePhotoCaptureDelegate {
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        guard error == nil else {
//            print("Fail to capture photo: \(String(describing: error))")
//            return
//        }
//
//        guard let imageData = photo.fileDataRepresentation() else {
//            print("Fail to convert pixel buffer")
//            return
//        }
//
//        guard let capturedImage = UIImage.init(data: imageData , scale: 1.0) else {
//            print("Fail to convert image data to UIImage")
//            return
//        }
//
//        let width = capturedImage.size.width
//        let height = capturedImage.size.height
//        let origin = CGPoint(x: (width - height)/2, y: (height - height)/2)
//        let size = CGSize(width: height, height: height)
//
//        guard let imageRef = capturedImage.cgImage?.cropping(to: CGRect(origin: origin, size: size)) else {
//            print("Fail to crop image")
//            return
//        }
//
//        let imageToSave = UIImage(cgImage: imageRef, scale: 1.0, orientation: .down)
//        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
//    }
//}
