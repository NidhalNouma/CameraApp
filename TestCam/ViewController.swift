//
//  ViewController.swift
//  TestCam
//
//  Created by mac on 27/10/2020.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var viewCam: UIView!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var drawBtn: UIButton!
    @IBOutlet weak var stylBtn: UIButton!
    @IBOutlet weak var takePicBtn: UIButton!
    @IBOutlet weak var photoBtn: UIButton!
    
    var videoDataOutput: AVCaptureVideoDataOutput!
    var videoDataOutputQueue: DispatchQueue!
    var previewLayer:AVCaptureVideoPreviewLayer!
    var captureDevice : AVCaptureDevice!
    let session = AVCaptureSession()
    var takePhoto = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCam.layer.cornerRadius = 30
        takePicBtn.layer.cornerRadius = 5
        drawBtn.layer.cornerRadius = 5
        stylBtn.layer.cornerRadius = 5
        clearBtn.layer.cornerRadius = 5
        
        photoBtn.setTitle("0 Photo", for: .normal)
        
        self.setupAVCapture()
    }
    
    @IBAction func flipClickBtn(_ sender: Any) {
    }
    @IBAction func takePhoto(_ sender: Any) {
        takePhoto = true
    }
    @IBAction func clearBtnClick(_ sender: Any) {
        Global.images = []
        photoBtn.setTitle("0 Photo", for: .normal)
    }
}

extension ViewController:  AVCaptureVideoDataOutputSampleBufferDelegate{

    func setupAVCapture(_ camera : Bool = true) {
        session.sessionPreset = AVCaptureSession.Preset.high
        guard let device = AVCaptureDevice
        .default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                 for: .video,
                 position: .back) else {
                            return
        }
        captureDevice = device
        beginSession()
    }

    func beginSession(){
        var deviceInput: AVCaptureDeviceInput!
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            guard deviceInput != nil else {
                print("error: cant get deviceInput")
                return
            }
            if self.session.canAddInput(deviceInput){
                self.session.addInput(deviceInput)
            }
            videoDataOutput = AVCaptureVideoDataOutput()
            videoDataOutput.alwaysDiscardsLateVideoFrames=true
            videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")
            videoDataOutput.setSampleBufferDelegate(self, queue:self.videoDataOutputQueue)

            if session.canAddOutput(self.videoDataOutput){
                session.addOutput(self.videoDataOutput)
            }

            videoDataOutput.connection(with: .video)?.isEnabled = true

            previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect

            let rootLayer :CALayer = self.viewCam.layer
            rootLayer.masksToBounds=true
            previewLayer.frame = rootLayer.bounds
            rootLayer.addSublayer(self.previewLayer)
            session.startRunning()
        } catch let error as NSError {
            deviceInput = nil
            print("error: \(error.localizedDescription)")
        }
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // do stuff here
        if takePhoto {
            takePhoto = false
            if let image = getImageFromBuffer(sampleBuffer) {
                Global.images.append(image)
//                print("my Image \(Global.images )")
                DispatchQueue.main.async {
                    self.photoBtn.setTitle("\(Global.images.count) Photo", for: .normal)
                }
            }
        }
    }
    
    private func getImageFromBuffer(_ buffer : CMSampleBuffer) -> UIImage? {
        guard let pixcelBuffer = CMSampleBufferGetImageBuffer(buffer) else {
            return nil
        }
        let ciImage = CIImage(cvPixelBuffer: pixcelBuffer)
        let context = CIContext()
        let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixcelBuffer), height: CVPixelBufferGetHeight(pixcelBuffer))
        guard let image = context.createCGImage(ciImage, from: imageRect) else {
            return nil
        }
        return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right )
    }

    // clean up AVCapture
    func stopCamera(){
        session.stopRunning()
    }
}
