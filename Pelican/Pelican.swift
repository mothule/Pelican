//
//  Pelican.swift
//  Pelican
//
//  Created by mothule on 2017/02/01.
//  Copyright © 2017年 mothule. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

extension String {
    /**
     # MD5形式ハッシュに変換する
     - returns MD5でハッシュ化した文字列
     */
    func md5() -> String {
        let utf8String = self.cString(using: .utf8)
        let len = CC_LONG(self.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(utf8String!, len, result)
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate(capacity: digestLen)
        return String(format:hash as String)
    }
}

extension UIImageView {
    
    /**
     # Load to a image data from network or local storage.
     
     - parameter url: Destination URL.
     */
    public func load(fromURL url:String)  {
        
        // キャッシュがあれば使う
        if let data = fetchFromFileCache(key: url) {
            print("Use cached file. \(url)")
            self.image = UIImage(data:data)
            
        }else{
            // 通信先から取得
            DispatchQueue.global().async{
                self.fetch(fromNetworkURL: url){ (image:UIImage?) in
                    guard let image = image else { return }
                    
                    // 取得成功したらキャッシュに保存
                    self.store(toFileCacheName: url, image: image)
                    
                    print("Download and Cache \(url)")
                    
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        }
    }
    
    
    /**
     # ネットワーク先から取得
     */
    private func fetch(fromNetworkURL url:String, completionHandler: @escaping (UIImage?) -> Void ) {
        
        guard let requestURL = URL(string:url) else {
            completionHandler(nil)
            return
        }
        
        let taskOfImage = URLSession.shared.dataTask(with: requestURL) { (data:Data?, res:URLResponse?, error:Error?) in
            let httpResponse = res as! HTTPURLResponse
            guard httpResponse.statusCode == 200, let data = data else {
                completionHandler(nil)
                return
            }
            completionHandler(UIImage(data: data))
        }
        taskOfImage.resume()
    }
    
    /**
     # ローカルファイル先にイメージデータを保存.
     */
    private func store(toFileCacheName key:String, image:UIImage) {
        
        // キャッシュ用ディレクトリの作成
        let cacheDir = pathOfCacheDictionary()
        if false == FileManager.default.fileExists(atPath: cacheDir) {
            do{
                try FileManager.default.createDirectory(atPath: cacheDir, withIntermediateDirectories: true, attributes: nil)
            }catch {
                print(error)
            }
        }
        
        // イメージを保存.
        do{
            guard let pngData = UIImagePNGRepresentation(image) else {
                print("Failed convert to png from UIImage")
                return
            }
            if let url = URL(string:pathForFileCache(hashedName: key.md5())) {
                try pngData.write(to: url)
            }
        }catch{
            print(error)
        }
    }
    
    /**
     # ファイルキャッシュからイメージデータを取得
     - parameter key: イメージデータへのキー
     - returns キーと紐づくイメージデータ. 見つからない場合はnil.
     */
    private func fetchFromFileCache(key:String) -> Data? {
        
        let filePath:String = pathForFileCache(hashedName: key.md5())
        do{
            let data = try Data(contentsOf: URL(string:filePath)! )
            return data
        }catch{
            print(error)
            return nil
        }
    }
    
    private func pathOfCacheDictionary() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let imagePath = paths.last! + "/Images"
        return imagePath
    }
    
    private func pathForFileCache(hashedName:String) -> String {
        let imagePath = pathOfCacheDictionary()
        let filePath:String = "file://\(imagePath)/\(hashedName).png"
        return filePath
    }
}
