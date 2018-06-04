//
//  MediaManager.swift
//  QNPlayerExample
//
//  Created by taoxiaofei on 2018/04/28.
//  Copyright © 2018年 taoxiaofei. All rights reserved.
//

import UIKit

class MediaManager {
     var player: QNPlayer?
     var mediaItem: MediaItem?
     var embeddedContentView: UIView?

    static let sharedInstance = MediaManager()
    private init(){

        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidPlayToEnd(_:)), name: NSNotification.Name.QNPlayerPlaybackDidFinish, object: nil)

    }

    func playEmbeddedVideo(url: URL, embeddedContentView contentView: UIView? = nil, userinfo: [AnyHashable : Any]? = nil) {
        var mediaItem = MediaItem()
        mediaItem.url = url
        self.playEmbeddedVideo(mediaItem: mediaItem, embeddedContentView: contentView, userinfo: userinfo )

    }

    func playEmbeddedVideo(mediaItem: MediaItem, embeddedContentView contentView: UIView? = nil , userinfo: [AnyHashable : Any]? = nil ) {
        //stop
        self.releasePlayer()

        if let skinView = userinfo?["skin"] as? UIView{
         self.player =  QNPlayer(controlView: skinView)
        }else{
          self.player = QNPlayer()
        }

        if let autoPlay = userinfo?["autoPlay"] as? Bool{
            self.player!.autoPlay = autoPlay
        }

        if let fullScreenMode = userinfo?["fullScreenMode"] as? QNPlayerFullScreenMode{
            self.player!.fullScreenMode = fullScreenMode
        }

        self.player!.closeButtonBlock = { fromDisplayMode in
            if fromDisplayMode == .embedded {
                self.releasePlayer()
            }else if fromDisplayMode == .fullscreen {
                if self.embeddedContentView == nil {
                    self.releasePlayer()
                }

            }
        }

        self.embeddedContentView = contentView

        self.player!.playWithURL(mediaItem.url! , embeddedContentView: self.embeddedContentView)
    }




    func releasePlayer(){
            self.player?.stop()
            self.player?.view.removeFromSuperview()

        self.player = nil
        self.embeddedContentView = nil
        self.mediaItem = nil

    }

    @objc  func playerDidPlayToEnd(_ notifiaction: Notification) {
       //结束播放关闭播放器
       //self.releasePlayer()

    }




}
