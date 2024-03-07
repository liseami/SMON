//
//  AliOSSManager.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import AliyunOSSiOS
import Foundation
import JDStatusBarNotification

@MainActor
class AliyunOSSManager {
    init() {
        self.OSSClient = getOSSClient()
    }

    static let shared: AliyunOSSManager = .init()

    var ossInfo: XMUserOSSTokenInfo {
        UserManager.shared.OSSInfo
    }

    var OSSClient: OSSClient?

    // 获取OSSClient
    func getOSSClient() -> OSSClient? {
        let OSSCredentialProvider = OSSStsTokenCredentialProvider(
            accessKeyId: ossInfo.accessKeyId,
            secretKeyId: ossInfo.accessKeySecret,
            securityToken: ossInfo.securityToken)
        return AliyunOSSiOS.OSSClient.init(endpoint: ossInfo.endpoint, credentialProvider: OSSCredentialProvider)
    }

    /*
     上传图片到OSS
     */
    func uploadImagesToOSS(images: [UIImage], progressCallback: @escaping (Int, Float) -> Void, completion: @escaping ([String]?) -> Void) {
        let bucketName = "dailycontest"
        var currentIndex = 0
        var uploadedImageURLs: [String] = []

        func uploadNextImage() {
            guard currentIndex < images.count else {
                // All images uploaded successfully
                completion(uploadedImageURLs)
                return
            }

            let image = images[currentIndex]
            let put = OSSPutObjectRequest()

            let imageName = "XM_iOS_UserPic_\(Date.now.string(withFormat: "yyyyMMddHHmm"))_\(String.random(ofLength: 12))" + ".jpg"
            let objectKey = AppConfig.env == .dev ? "app/test/\(imageName)" : "app/prod/\(imageName)"
            put.bucketName = bucketName
            put.objectKey = objectKey

            // guard let data = compressImage(image) else { completion(nil); return }

            put.uploadingData = image.jpegData(compressionQuality: 0.3)!
            // 当前上传长度、当前已上传总长度、待上传的总长度。
            put.uploadProgress = { _, totalByteSent, totalBytesExpectedToSend in
                let progress = Float(totalByteSent) / Float(totalBytesExpectedToSend)
                progressCallback(currentIndex + 1, progress)
            }

            let putTask = OSSClient?.putObject(put)

            putTask?.continue(with: .default(), with: { task in
                if let _ = task.error {
                    // Error occurred, stop the process and report the error
                    completion(nil)
                } else {
                    // Current image uploaded successfully, add the URL to the array
                    let imageURL = "\(objectKey)"
                    uploadedImageURLs.append(imageURL)
                    currentIndex += 1
                    uploadNextImage()
                }
                return
            })
        }

        // Start uploading the first image
        uploadNextImage()
    }

    func upLoadImages(images: [UIImage], completion: @escaping ([String]?) -> Void) {
        uploadImagesToOSS(images: images) { currentImage, totalProgress in
            // 处理当前图片上传进度和整体进度
            print("上传第 \(currentImage) 张图片，总体进度: \(totalProgress * 100)%")
            DispatchQueue.main.async {
                Apphelper.shared.pushProgressNotification(text: "(\(currentImage)/\(images.count))正在上传...") { presenter in
                    presenter.displayProgressBar(at: Double(totalProgress))
                }
            }
        } completion: { urls in
            if let urls {
                print("所有图片上传成功，URLs: \(urls)")
                completion(urls)
                DispatchQueue.main.async {
                    NotificationPresenter.shared.dismiss()
                    Apphelper.shared.pushNotification(type: .success(message: "上传完成。"))
                }
            } else {
                print("某张图片上传失败，整体失败。")
                completion(nil)
                DispatchQueue.main.async {
                    NotificationPresenter.shared.dismiss()
                    Apphelper.shared.pushNotification(type: .error(message: "上传失败，请重试。"))
                }
            }
        }
    }

    func upLoadImages_async(images: [UIImage]) async -> [String]? {
        return await withCheckedContinuation { continuation in
            upLoadImages(images: images) { urls in
                if let urls {
                    continuation.resume(returning: urls)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}

func compressImage(_ image: UIImage) -> Data? {
    var imageData = image.jpegData(compressionQuality: 0.9)

    while let data = imageData, data.count > 250000 {
        imageData = UIImage(data: data)?.jpegData(compressionQuality: 0.9)
    }

    if let data = imageData {
        return data
    } else {
        return nil
    }
}
