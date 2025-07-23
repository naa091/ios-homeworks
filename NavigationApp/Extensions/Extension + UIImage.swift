import UIKit
// MARK: - UIImage Memory Optimization

extension UIImage {
    func downsampled(maxDimension: CGFloat) -> UIImage? {
        let aspectRatio = size.width / size.height
        let targetSize: CGSize
        
        if aspectRatio > 1 {
            targetSize = CGSize(width: maxDimension, height: maxDimension / aspectRatio)
        } else {
            targetSize = CGSize(width: maxDimension * aspectRatio, height: maxDimension)
        }
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
