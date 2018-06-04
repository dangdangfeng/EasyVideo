//
//  QNPlayerThumbnail.swift
//  QNPlayer
//
//  Created by taoxiaofei on 2018/04/28.
//  Copyright © 2018年 taoxiaofei. All rights reserved.
//

import AVFoundation
import UIKit

public struct QNPlayerThumbnail {
    public var requestedTime: CMTime
    public var image: UIImage?
    public var actualTime: CMTime
    public var result: AVAssetImageGeneratorResult
    public var error: Error?
}
