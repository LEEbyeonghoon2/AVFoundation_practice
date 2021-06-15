//
//  takePictureVC.swift
//  oneDrop_assignment
//
//  Created by 이병훈 on 2021/06/12.
//

import Foundation
import UIKit

class takePictureVC: UIViewController {
    var image: UIImage?
    @IBOutlet weak var imageVIew: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* image 설정 */
        let graphicsImage = drawRectangleOnImage(image: image!)
        self.imageVIew.image = graphicsImage
        
        self.imageVIew.contentMode = .scaleToFill

        let data = image!.pixelData(x: 253, y: 650)
        
        /* label 설정 */
        let label = UILabel(frame: CGRect(x: 30, y: 30, width: 100, height: 30))
        label.backgroundColor = .lightGray
        label.text = "R: \(data[0]), G:\(data[1]), B:\(data[2])"
        label.sizeToFit()
        
        self.imageVIew.addSubview(label)
    }
    
    /* pointView 설정 */
    func drawRectangleOnImage(image: UIImage) -> UIImage {
        let imageSize = image.size
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)

        image.draw(at: CGPoint.zero)

        let rectangle = CGRect(x: 238, y: 635, width: 30, height: 30)

        UIColor.red.setFill()
        UIRectFill(rectangle)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext() // stack 메모리에서 비트맵 이미지를 제거
        return newImage!
    }
    
}
extension UIImage {
    /* rgbdata 뽑아내기 */
    func pixelData(x: Float, y: Float) -> [Int] {
        var rgb: [Int] = []
        let bmp = self.cgImage!.dataProvider!.data
        let data = CFDataGetBytePtr(bmp)
        var sumR = Int(0), sumG = Int(0), sumB = Int(0)
        
        let bytesPerPixel = cgImage!.bitsPerPixel / cgImage!.bitsPerComponent //픽셀의 한 비트
        
        print(bytesPerPixel) // 4
        print(cgImage!.bytesPerRow) // 5120
        print(cgImage!.bitsPerComponent) // 8
        print(cgImage!.bitsPerPixel) // 32
        
        for y in Int(y - 15)..<Int(y + 15) {
            for x in Int(x - 15)..<Int(x + 15) {
                let offset = (y * cgImage!.bytesPerRow) + (x * bytesPerPixel)
                sumR += Int(data![offset])
                sumG += Int(data![offset + 1])
                sumB += Int(data![offset + 2])
            }
        }
        // 평균 계산하고 배열에 추가
        rgb.append(sumR / 900)
        rgb.append(sumG / 900)
        rgb.append(sumB / 900)
        
        return rgb
    }
}


