import UIKit

// TODO: - 이 파일 위치가 좀 애매한데... 우리 Global 안에 Util 폴더를 만들면 어떨까?
struct ImageCompressor {
    static private var literalFor1MB = 1024 * 1024
    static private var literalFor5MB = 5 * literalFor1MB
    static private var literalFor10MB = 10 * literalFor1MB
    
    /// 비동기적으로 이미지를 압축하여 maxByte 이하로 줄인다
    /// - 이미지 크기가 maxByte 이하가 될 때까지 압축을 반복
    /// - 완료 후 압축된 데이터를 completion을 통해 반환
    static func compress(
        image: UIImage,
        maxByte: Int = literalFor1MB,
        completion: @escaping (Data?) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            var compressedData: Data? = image.jpegData(compressionQuality: 1.0)
            guard let currentImageSize = compressedData?.count else {
                return completion(nil)
            }
        
            var iterationImageSize: Int = currentImageSize
            var iterationCompression: CGFloat = 1.0
            
            while compressedData != nil && iterationImageSize > maxByte && iterationCompression > 0.0 {
                let percentageToDecrease = getPercentageToDecreaseTo(imageSize: iterationImageSize)
                compressedData = image.jpegData(compressionQuality: iterationCompression)
                iterationImageSize = compressedData?.count ?? 0
                iterationCompression -= percentageToDecrease
            }
            
            completion(compressedData)
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
