//
//  Global.swift
//  TestCam
//
//  Created by mac on 27/10/2020.
//

import UIKit
import AVFoundation

class Global {
    
    static var images:[UIImage] = []
    
    
    static func authoriCam() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                print("authorized")
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        print("authorized notDet")
                    }
                }
            case .denied:
                return
            case .restricted:
                return
        @unknown default:
            print("authorized default")
        }
    }
}

