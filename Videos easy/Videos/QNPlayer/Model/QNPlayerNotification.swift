//
//  QNPlayerNotification.swift
//  QNPlayer
//
//  Created by taoxiaofei on 2018/04/28.
//  Copyright © 2018年 taoxiaofei. All rights reserved.
//

import Foundation

public extension Notification.Name {
    /// QNPlayer生命周期
    static let QNPlayerHeartbeat = Notification.Name(rawValue: "com.qnplayer.QNPlayerHeartbeat")

    /// addPeriodicTimeObserver方法的触发
    static let QNPlayerPlaybackTimeDidChange = Notification.Name(rawValue: "com.qnplayer.QNPlayerPlaybackTimeDidChange")

    /// 播放器状态改变
    static let QNPlayerStatusDidChange = Notification.Name(rawValue: "com.qnplayer.QNPlayerStatusDidChange")

    /// 视频结束
    static let QNPlayerPlaybackDidFinish = Notification.Name(rawValue: "com.qnplayer.QNPlayerPlaybackDidFinish")

    /// loading状态改变
    static let QNPlayerLoadingDidChange = Notification.Name(rawValue: "com.qnplayer.QNPlayerLoadingDidChange")

    /// 播放器控制条隐藏显示
    static let QNPlayerControlsHiddenDidChange = Notification.Name(rawValue: "com.qnplayer.QNPlayerControlsHiddenDidChange")

    /// 播放器显示模式改变了（全屏，嵌入屏，浮动）
    static let QNPlayerDisplayModeDidChange = Notification.Name(rawValue: "com.qnplayer.QNPlayerStatusDidChang")
    /// 播放器显示模式动画开始
    static let QNPlayerDisplayModeChangedWillAppear = Notification.Name(rawValue: "QNPlayerDisplayModeChangedWillAppear")
    /// 播放器显示模式动画结束
    static let QNPlayerDisplayModeChangedDidAppear = Notification.Name(rawValue: "QNPlayerDisplayModeChangedDidAppear")

    /// 点击播放器手势通知
    static let QNPlayerTapGestureRecognizer = Notification.Name(rawValue: "com.qnplayer.QNPlayerTapGestureRecognizer")

    /// FairPlay DRM
    static let QNPlayerDidPersistContentKey = Notification.Name(rawValue: "com.qnplayer.QNPlayerDidPersistContentKey")
}

public extension Notification {
    public struct Key {
        /// 播放器状态改变
        public static let QNPlayerNewStateKey = "QNPlayerNewStateKey"
        public static let QNPlayerOldStateKey = "QNPlayerOldStateKey"

        /// 视频结束
        public static let QNPlayerPlaybackDidFinishReasonKey = "QNPlayerPlaybackDidFinishReasonKey"

        /// loading状态改变
        public static let QNPlayerLoadingDidChangeKey = "QNPlayerLoadingDidChangeKey"

        /// 播放器控制条隐藏显示
        public static let QNPlayerControlsHiddenDidChangeKey = "QNPlayerControlsHiddenDidChangeKey"
        public static let QNPlayerControlsHiddenDidChangeByAnimatedKey = "QNPlayerControlsHiddenDidChangeByAnimatedKey"

        /// 播放器显示模式改变了（全屏，嵌入屏，浮动）
        public static let QNPlayerDisplayModeDidChangeKey = "QNPlayerDisplayModeDidChangeKey"
        public static let QNPlayerDisplayModeChangedFrom = "QNPlayerDisplayModeChangedFrom"
        public static let QNPlayerDisplayModeChangedTo = "QNPlayerDisplayModeChangedTo"

        /// 点击播放器手势通知
        public static let QNPlayerNumberOfTaps =  "QNPlayerNumberOfTaps"
        public static let QNPlayerTapGestureRecognizer =  "QNPlayerTapGestureRecognizer"

        /// FairPlay DRM=
        public static let QNPlayerDidPersistAssetIdentifierKey = "QNPlayerDidPersistAssetIdentifierKey"
    }
}
