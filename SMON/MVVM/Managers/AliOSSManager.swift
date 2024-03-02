//
//  AliOSSManager.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import AliyunOSSiOS
import Foundation
import JDStatusBarNotification

class AliyunOSSManager {
    static let shared: AliyunOSSManager = .init()
    let endPoint = "https://oss-cn-shanghai.aliyuncs.com"
    var OSSClient: OSSClient?
    init() {
        self.OSSClient = self.getOSSClient()
    }

    // 获取OSSClient
    func getOSSClient() -> OSSClient? {
        let OSSCredentialProvider = OSSStsTokenCredentialProvider(
            accessKeyId: "STS.NTtMd6SVxRqx1AoifiUSe7h9S",
            secretKeyId: "8WKZBb59ZHEJDpTuuDGWemZYvhh3dSMFGfwHxiFtr9yu",
            securityToken: "CAISlAJ1q6Ft5B2yfSjIr5fBBt6CvolZ5bOTM2fejWY8WdxJ2K2SsTz2IHhMdXZqAugZs/s0mGlQ7/4elq9JQppiXlecnXOkciIOo22beIPkl5Gf9t5t0e+jewW6Dxr8w7WdAYHQR8/cffGAck3NkjQJr5LxaTSlWS7CU/iOkoU1VskLeQO6YDFafoM0QDFvs8gHL3DcGO+wOxrx+ArqAVFvpxB3hBE3i9K2ydbO7QHF3h+oiL0ZroX1M5OjadVhJ4s4Ws+tm65UDvOfinYJt0AVqP4r1/AUp2r904vDUwUL0XKvKPHJ99BjFgh9a5UhFrRMxPqGzqUg67OJzNyolkkWYbgNCnyDXu66yc7DA/i5z3fb1ngjox4agAE91r4s1alWdVo1kkUYGJ/GZk41oRv9gaalOhh+p9ZS95STL3pPwafD9OB58Qi3EeEa4onOz89/p4LHB4xAYLiQgDFx5X7eT7jFn+EwxOSlPbNNe3VPM5Hs0vD5MG9Q9NkW+cq35G+wVchLPqYiv0shSnNsFPy4yysVYHE8rYpw1SAA")
        return AliyunOSSiOS.OSSClient.init(endpoint: self.endPoint, credentialProvider: OSSCredentialProvider)
    }

    // 上传图片到OSS
    func uploadImagesToOSS(image: UIImage, progressCallback: @escaping (Int, Float) -> Void, completion: @escaping ([String]?, Error?) -> Void) {
        let put = OSSPutObjectRequest()
        let bucketName = "dailycontest"
        let imageName = "XM_iOS_UserPic_\(Date.now.string(withFormat: "yyyyMMddHHmm"))_\(String.random(ofLength: 12))" + ".jpg"
        let objectKey = "app/test/\(imageName)"
        put.bucketName = bucketName
        put.objectKey = objectKey

        if let data = image.jpegData(compressionQuality: 1) {
            put.uploadingData = NSData(data: data) as Data
        }

        // 当前上传长度、当前已上传总长度、待上传的总长度。
        put.uploadProgress = { bytesSent, totalByteSent, totalBytesExpectedToSend in
            print(bytesSent, totalByteSent, totalBytesExpectedToSend)
        }

        let putTask = self.OSSClient?.putObject(put)

        putTask?.continue(with: .default(), with: { task in
            if task.error == nil {
                print("上传成功")
            } else {
                print("上传失败")
            }
        })
    }

//    // 上传多张图片并返回URL数组
//    func upLoadImages(images: [UIImage], completion: @escaping ([String]?, Error?) -> Void) {
//        self.uploadImagesToOSS(images: images, progressCallback: { currentImage, totalProgress in
//            // 处理当前图片上传进度和整体进度
//            print("上传第 \(currentImage) 张图片，总体进度: \(totalProgress * 100)%")
//            print("上传第 \(currentImage) 张图片，总体进度: \(totalProgress * 100)%")
//            DispatchQueue.main.async {
//                Apphelper.shared.pushProgressNotification(text: "(\(currentImage)/\(images.count))正在上传...") { presenter in
//                    presenter.animateProgressBar(to: Double(totalProgress), duration: 0.1) { _ in
//                    }
//                }
//            }
//        }, completion: { uploadedUrls, error in
//            if let uploadedUrls = uploadedUrls {
//                print("所有图片上传成功，URLs: \(uploadedUrls)")
//                DispatchQueue.main.async {
//                    NotificationPresenter.shared.dismiss(animated: true)
//                }
//                completion(uploadedUrls, nil)
//            } else {
//                DispatchQueue.main.async {
//                    NotificationPresenter.shared.dismiss()
//                    Apphelper.shared.pushNotification(type: .error(message: "上传失败，请重试。"))
//                }
//                print("上传失败，错误信息：\(error?.localizedDescription ?? "Unknown Error")")
//                completion(nil, error)
//            }
//        })
//    }
}
