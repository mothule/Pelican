//
//  HogeLogic.swift
//  Demo
//
//  Created by mothule on 2017/02/01.
//  Copyright © 2017年 mothule. All rights reserved.
//

import Foundation

protocol HogeLogic {
    func fetchImageName() -> [String]
}

struct HogeLogicImpl: HogeLogic {
    func fetchImageName() -> [String] {
        let images:[String] = [
            "https://placehold.jp/150x150.png",
            "https://placehold.jp/100x150.png",
            "https://placehold.jp/150x100.png",
            "https://placehold.jp/100x100.png",
            "https://placehold.jp/50x100.png",
            "https://placehold.jp/100x50.png",
            "https://placehold.jp/50x50.png",
        ]
        let length = Int(arc4random()) % images.count
        
        let results:[String] = images.prefix(length).map { $0 }
        return results
    }
}
