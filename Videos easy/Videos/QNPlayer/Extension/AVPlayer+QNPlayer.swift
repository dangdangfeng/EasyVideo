//
//  AVPlayer+QNPlayer.swift
//  QNPlayer
//
//  Created by taoxiaofei on 2017/1/12.
//  Copyright © 2018年 taoxiaofei. All rights reserved.
//

import AVFoundation

public extension AVPlayer {
    /// 观看了的时长（不包括暂停等）
    public var durationWatched: TimeInterval {
        var duration: TimeInterval = 0
        if let events = self.currentItem?.accessLog()?.events {
            for event in events {
               duration += event.durationWatched
            }
        }
        return duration
    }

    /// 总时长
    public var duration: TimeInterval? {
        if let  duration = self.currentItem?.duration  {
            return CMTimeGetSeconds(duration)
        }
        return nil
    }

    /// 播放进度
    public var currentTime: TimeInterval? {
            return CMTimeGetSeconds(self.currentTime())
    }

}
