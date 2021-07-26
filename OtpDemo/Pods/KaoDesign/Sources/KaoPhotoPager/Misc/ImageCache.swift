//
//  KaoImageCache.swift
//  Ubud
//
//  Created by Luqman Fauzi on 10/12/2017.
//  Copyright © 2017 Luqman Fauzi. All rights reserved.
//

import UIKit

final internal class KaoImageCache {

    private init() { }

    static let shared = KaoImageCache()
    private let cache = NSCache<NSString, UIImage>()

    func set(key: String, image: UIImage) {
        cache.setObject(image, forKey: key as NSString)
    }

    func get(key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}
