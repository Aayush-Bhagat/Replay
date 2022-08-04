//
//  CameraViewController.swift
//  Replay
//
//  Created by Aayush Bhagat on 7/28/22.
//

import AVFoundation
import UIKit

class CameraViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    @IBOutlet weak var camPreview: UIView!
    
    @IBOutlet weak var cameraButton: UIButton!

       let captureSession = AVCaptureSession()

       let movieOutput = AVCaptureMovieFileOutput()

       var previewLayer: AVCaptureVideoPreviewLayer!

       var activeInput: AVCaptureDeviceInput!

       var outputURL: URL!

       override func viewDidLoad() {
           super.viewDidLoad()
       
//           if setupSession() {
//               setupPreview()
//               startSession()
//           }
//
//           cameraButton.isUserInteractionEnabled = true
       
           let cameraButtonRecognizer = UITapGestureRecognizer(target: self, action: #selector(CameraViewController.startCapture))
//
           cameraButton.addGestureRecognizer(cameraButtonRecognizer)
//
//           cameraButton.backgroundColor = UIColor.clear
//           cameraButton.layer.borderWidth = 5.0
//           cameraButton.layer.cornerRadius = cameraButton.frame.width/2
//           cameraButton.layer.borderColor = UIColor.white.cgColor
//
//           camPreview.addSubview(cameraButton)
       
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        
        if setupSession() {
            setupPreview()
            startSession()
        }
        
        cameraButton.isUserInteractionEnabled = true
        cameraButton.backgroundColor = UIColor.clear
        cameraButton.layer.borderWidth = 5.0
        cameraButton.layer.cornerRadius = cameraButton.frame.width/2
        cameraButton.layer.borderColor = UIColor.white.cgColor
        camPreview.addSubview(cameraButton)
    }
        
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        captureSession.stopRunning()
    }

       func setupPreview() {
           // Configure previewLayer
           previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
           previewLayer.frame = camPreview.bounds
           previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
           camPreview.layer.addSublayer(previewLayer)
       }

       //MARK:- Setup Camera

       func setupSession() -> Bool {
       
           captureSession.sessionPreset = AVCaptureSession.Preset.hd1280x720
       
           // Setup Camera
           let camera = AVCaptureDevice.default(for: AVMediaType.video)!
       
           do {
           
               let input = try AVCaptureDeviceInput(device: camera)
           
               if captureSession.canAddInput(input) {
                   captureSession.addInput(input)
                   activeInput = input
               }
           } catch {
               print("Error setting device video input: \(error)")
               return false
           }
       
           // Setup Microphone
           let microphone = AVCaptureDevice.default(for: AVMediaType.audio)!
       
           do {
               let micInput = try AVCaptureDeviceInput(device: microphone)
               if captureSession.canAddInput(micInput) {
                   captureSession.addInput(micInput)
               }
           } catch {
               print("Error setting device audio input: \(error)")
               return false
           }
       
       
           // Movie output
           if captureSession.canAddOutput(movieOutput) {
               captureSession.addOutput(movieOutput)
           }
       
           return true
       }

       func setupCaptureMode(_ mode: Int) {
           // Video Mode
       
       }

       //MARK:- Camera Session
       func startSession() {
       
           if !captureSession.isRunning {
               videoQueue().async {
                   self.captureSession.startRunning()
               }
           }
       }

       func stopSession() {
           if captureSession.isRunning {
               videoQueue().async {
                   self.captureSession.stopRunning()
               }
           }
       }

       func videoQueue() -> DispatchQueue {
           return DispatchQueue.main
       }

       func currentVideoOrientation() -> AVCaptureVideoOrientation {
           var orientation: AVCaptureVideoOrientation
       
           switch UIDevice.current.orientation {
               case .portrait:
                   orientation = AVCaptureVideoOrientation.portrait
               case .landscapeRight:
                   orientation = AVCaptureVideoOrientation.landscapeLeft
               case .portraitUpsideDown:
                   orientation = AVCaptureVideoOrientation.portraitUpsideDown
               default:
                    orientation = AVCaptureVideoOrientation.portrait
            }
       
            return orientation
        }

       @objc func startCapture() {
       
           startRecording()
       
       }

       //EDIT 1: I FORGOT THIS AT FIRST

       func tempURL() -> URL? {
           let directory = NSTemporaryDirectory() as NSString
       
           if directory != "" {
               let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
               return URL(fileURLWithPath: path)
           }
       
           return nil
       }

       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
           let vc = segue.destination as! VideoPlayback
       
           vc.videoURL = sender as? URL
       
       }

       func startRecording() {
           cameraButton.backgroundColor = UIColor.systemRed
       
           if movieOutput.isRecording == false {
           
               let connection = movieOutput.connection(with: AVMediaType.video)
           
               if (connection?.isVideoOrientationSupported)! {
                   connection?.videoOrientation = currentVideoOrientation()
               }
           
               if (connection?.isVideoStabilizationSupported)! {
                   connection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
               }
           
               let device = activeInput.device
           
               if (device.isSmoothAutoFocusSupported) {
               
                   do {
                       try device.lockForConfiguration()
                       device.isSmoothAutoFocusEnabled = false
                       device.unlockForConfiguration()
                   } catch {
                      print("Error setting configuration: \(error)")
                   }
               
               }
           
               //EDIT2: And I forgot this
               outputURL = tempURL()
               movieOutput.startRecording(to: outputURL, recordingDelegate: self)
           
               }
               else {
                   stopRecording()
               }
       
          }

      func stopRecording() {
          cameraButton.backgroundColor = UIColor.clear
          
          if movieOutput.isRecording == true {
              movieOutput.stopRecording()
           }
      }

       func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
       
       }

       func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
       
           if (error != nil) {
           
               print("Error recording movie: \(error!.localizedDescription)")
           
           } else {
           
               let videoRecorded = outputURL! as URL
               outputURL.removeAllCachedResourceValues()
               performSegue(withIdentifier: "showVideo", sender: videoRecorded)
               
               
           
           }
       
       }
    
    
}
