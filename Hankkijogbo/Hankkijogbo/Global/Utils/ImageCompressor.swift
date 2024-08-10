import UIKit

struct ImageCompressor {
    static private var literalFor1MB: Int = 1024 * 1024
    static private var literalFor5MB: Int = 5 * literalFor1MB
    static private var literalFor10MB: Int = 10 * literalFor1MB
    
    /// 비동기적으로 이미지를 압축하여 maxByte 이하의 크기가 되도록
    /// - 최대 압축을 해도 1MB가 넘어가는 이미지면 바로 nil을 반환
    /// - 이미지 크기가 maxByte 이하가 되는 압축 비율을 찾을 때까지 로직 반복
    /// - 찾으면 압축된 데이터를 completion을 통해 반환
    static func compress(
        image: UIImage,
        maxByte: Int = literalFor1MB,
        completion: @escaping (Data?) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            if image.jpegData(compressionQuality: 0.0)?.count ?? 0 > literalFor1MB {
                return completion(nil)
            }
            
            var compression: CGFloat = 1.0
            var data: Data? = image.jpegData(compressionQuality: compression)
            guard let initialImageSize = data?.count else { return completion(nil) }
            var imageSize: Int = initialImageSize
            
            while data != nil && imageSize > maxByte && compression > 0.0 {
                let percentageToDecrease = getPercentageToDecreaseTo(imageSize: imageSize)
                compression -= percentageToDecrease
                data = image.jpegData(compressionQuality: compression)
                imageSize = data?.count ?? 0
            }
            
            completion(data)
        }
    }

    /// 현재 이미지 데이터 크기에 따른 압축 비율 반환
    private static func getPercentageToDecreaseTo(imageSize: Int) -> CGFloat {
        switch imageSize {
        case 0..<literalFor5MB:
            return 0.03
        case literalFor5MB..<literalFor10MB:
            return 0.1
        default:
            return 0.2
        }
    }
}
