import UIKit
extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
extension CGRect {
    func scaled(_ scale: CGFloat) -> CGRect {
        return CGRect(x: origin.x * scale, y: origin.y * scale, width: size.width * scale, height: size.height * scale)
    }
}
extension UIImage {
    func cropp(to size: CGSize, anchorOn anchor: CGPoint) -> UIImage {
        guard let cgImage = self.cgImage else { assertionFailure("[@Color] Crop only works for CG-based image."); return self };
        let rect = self.constrainedRect(for: size, anchor: anchor);
        guard let image = cgImage.cropping(to: rect.scaled(scale))
        else { assertionFailure("[Kingfisher] Cropping image failed."); return self };
        return .init(cgImage: image, scale: scale, orientation: .up)
    }
    
    func constrainedRect(for size: CGSize, anchor: CGPoint) -> CGRect {
        let unifiedAnchor = CGPoint(x: anchor.x.clamped(to: 0.0...1.0),y: anchor.y.clamped(to: 0.0...1.0))
        let x = unifiedAnchor.x * self.size.width - unifiedAnchor.x * size.width
        let y = unifiedAnchor.y * self.size.height - unifiedAnchor.y * size.height
        let r = CGRect(x: x, y: y, width: size.width, height: size.height)
        let ori = CGRect(origin: .zero, size: self.size)
        return ori.intersection(r)
    }
}

extension UIImage {
    func getColorTint() -> UIColor? {
        if let cropped = self.cropp(to: CGSize(width: 52, height: 52), anchorOn: .zero).cgImage {
            let inputImage = CIImage(cgImage: cropped)
            let extentVector = CIVector(
                x: inputImage.extent.origin.x,
                y: inputImage.extent.origin.y,
                z: inputImage.extent.size.width,
                w: inputImage.extent.size.height
            )
            
            if let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) {
                if let outputImage = filter.outputImage {
                    var bitmap = [UInt8](repeating: 0, count: 4)
                    let context = CIContext()
                    context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
                    return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
                }
            }
        }
        
        return .empty
    }
    
    func getColorPrimary() -> UIColor? {
        if let cgImage = self.cgImage {
            let inputImage = CIImage(cgImage: cgImage)
            let extentVector = CIVector(
                x: inputImage.extent.origin.x,
                y: inputImage.extent.origin.y,
                z: inputImage.extent.size.width,
                w: inputImage.extent.size.height
            )
            if let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) {
                if let outputImage = filter.outputImage {
                    var bitmap = [UInt8](repeating: 0, count: 4)
                    let context = CIContext()
                    context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
                    return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
                }
            }
        }
        
        return nil
    }
}
