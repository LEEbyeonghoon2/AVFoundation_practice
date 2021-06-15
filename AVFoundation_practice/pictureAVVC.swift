//
//  ViewController.swift
//  oneDrop_assignment
//
//  Created by 이병훈 on 2021/06/12.
//

import UIKit
import AVFoundation

class pictureAVVC: UIViewController {
    
    @IBOutlet weak var clikButton: UIButton!
    let session = AVCaptureSession() //카메라 아웃풋하고 인풋 관리
    var camera: AVCaptureDevice?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var cameraCaptureOutPut: AVCapturePhotoOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initalizeCaptureSession()
    }
    /* 찍은 사진 다음 화면에 전달하고 push하기 */
    func takePicutre(image: UIImage) {
        let vc = self.storyboard?.instantiateViewController(identifier: "takePictureVC") as! takePictureVC
        
        vc.image = image
        
        navigationController?.pushViewController(vc, animated: true)
    }
    /* 버튼을 클릭시 사진 찍기 */
    @IBAction func click_button(_ sender: Any) {
        capturePicture()
    }
    
    /* 카메라 옵션 설정 및 실행 */
    func initalizeCaptureSession() {
        
        //카메라 옵셔 설정
        session.sessionPreset = AVCaptureSession.Preset.hd1280x720
        
        camera = AVCaptureDevice.default(for: .video)
        
        do {
            let cameraCaptureInput = try AVCaptureDeviceInput(device: camera!)
            cameraCaptureOutPut = AVCapturePhotoOutput()
            session.addInput(cameraCaptureInput)
            session.addOutput(cameraCaptureOutPut!)
        } catch {
            print(error.localizedDescription)
        }
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraPreviewLayer?.videoGravity = .resizeAspectFill
        cameraPreviewLayer?.frame = self.view.bounds
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.view.layer.addSublayer(cameraPreviewLayer!)
        self.view.bringSubviewToFront(clikButton)
        
        //카메라 작동
        session.startRunning()
    }
    
    func capturePicture() {
        let settings = AVCapturePhotoSettings()
        //플래시모드
        settings.flashMode = .off
        cameraCaptureOutPut?.capturePhoto(with: settings, delegate: self)
    }
}
extension pictureAVVC : AVCapturePhotoCaptureDelegate {
    /* 찍은 사진 전달하는 델리게이트 메서드 */
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            let data = photo.fileDataRepresentation()
            let image = UIImage(data: data!)
            takePicutre(image: image!)
        }
    }
}
