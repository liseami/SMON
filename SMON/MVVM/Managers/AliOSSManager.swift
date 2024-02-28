//
//  AliOSSManager.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import Foundation

class AliyunOSSManager {
    static let shared: AliyunOSSManager = .init()
    
    var OSSClient : OSSClient?
    init(){
        self.OSSClient = getOSSClient()
    }
    func getOSSClient() -> OSSClient? {
        
        let endPoint = "https://oss-cn-shanghai.aliyuncs.com"
        let OSSCredentialProvider = OSSStsTokenCredentialProvider(
            accessKeyId: "STS.NTtMd6SVxRqx1AoifiUSe7h9S",
            secretKeyId: "8WKZBb59ZHEJDpTuuDGWemZYvhh3dSMFGfwHxiFtr9yu",
            securityToken: "CAISlAJ1q6Ft5B2yfSjIr5fBBt6CvolZ5bOTM2fejWY8WdxJ2K2SsTz2IHhMdXZqAugZs/s0mGlQ7/4elq9JQppiXlecnXOkciIOo22beIPkl5Gf9t5t0e+jewW6Dxr8w7WdAYHQR8/cffGAck3NkjQJr5LxaTSlWS7CU/iOkoU1VskLeQO6YDFafoM0QDFvs8gHL3DcGO+wOxrx+ArqAVFvpxB3hBE3i9K2ydbO7QHF3h+oiL0ZroX1M5OjadVhJ4s4Ws+tm65UDvOfinYJt0AVqP4r1/AUp2r904vDUwUL0XKvKPHJ99BjFgh9a5UhFrRMxPqGzqUg67OJzNyolkkWYbgNCnyDXu66yc7DA/i5z3fb1ngjox4agAE91r4s1alWdVo1kkUYGJ/GZk41oRv9gaalOhh+p9ZS95STL3pPwafD9OB58Qi3EeEa4onOz89/p4LHB4xAYLiQgDFx5X7eT7jFn+EwxOSlPbNNe3VPM5Hs0vD5MG9Q9NkW+cq35G+wVchLPqYiv0shSnNsFPy4yysVYHE8rYpw1SAA")
        return AliyunOSSiOS.OSSClient.init(endpoint: endPoint, credentialProvider: OSSCredentialProvider)
    }
    
    func uploadImageToOSS(image: UIImage) {
        
        let put = OSSPutObjectRequest()
        
        // 填写Bucket名称，例如examplebucket。
        put.bucketName = "dailycontest"
        let imageName = String.random(ofLength: 12) + ".jpg"
        // 填写Object完整路径。Object完整路径中不能包含Bucket名称，例如exampledir/testdir/exampleobject.txt。
        put.objectKey = "app/test/\(imageName)"
        
        // 直接上传NSData。
        if let data = image.jpegData(compressionQuality: 0.3) {
            put.uploadingData = NSData(data: data) as Data
        }
//
//
        put.uploadProgress = { bytesSent, totalByteSent, totalBytesExpectedToSend in
            print("\(bytesSent), \(totalByteSent), \(totalBytesExpectedToSend)")
        }
//
        let putTask = self.OSSClient?.putObject(put)
        
        putTask?.continue(with: .default(), with: { task in
            if let error = task.error {
                print(error)
            } else {
                print("上传成功")
            }
        })
        
        // 不需要等待任务完成，Swift中一般使用异步回调处理
    }
}
