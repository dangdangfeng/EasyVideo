//
//  QNPlayerLayerView.swift
//  QNPlayer
//
//  Created by taoxiaofei on 2018/04/28.
//  Copyright © 2018年 taoxiaofei. All rights reserved.
//

import UIKit
import AVFoundation

class QNPlayerView: UIView {
    //播放器属性
    weak private var player: QNPlayer?

    weak var controlView: UIView?{
        didSet{
            if oldValue != controlView{
                oldValue?.removeFromSuperview()
                self.addSubview(controlView!)
                self.setNeedsDisplay()
                if let customAction =  controlView as? QNPlayerCustomAction{
                    customAction.player = player
                }
            }
        }
    }

    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    //手势属性
    open var panGesture: UIPanGestureRecognizer!
    open var singleTapGesture: UITapGestureRecognizer!
    open var doubleTapGesture: UITapGestureRecognizer!
    private var trigger = QNPlayerSlideTrigger.none
    private var isHorizontalPan = true
    private var position : TimeInterval?

    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        self.commonInit()
    }

    init(controlView: UIView? ) {
        super.init(frame: CGRect.zero)
        self.controlView = controlView
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.controlView?.frame = self.bounds
    }

    // MARK: - public
    func config(player: QNPlayer){
        (self.layer as! AVPlayerLayer).player = player.player
        if let customAction =  self.controlView as? QNPlayerCustomAction{
            customAction.player = player
        }
        self.player = player
    }

    // MARK: - private
    private func commonInit() {
        self.clipsToBounds = true
        self.backgroundColor = UIColor.black
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth,.flexibleLeftMargin,.flexibleTopMargin,.flexibleRightMargin,.flexibleBottomMargin]

        self.controlView?.autoresizingMask = [.flexibleLeftMargin,.flexibleTopMargin,.flexibleRightMargin,.flexibleBottomMargin]
        self.addSubview(self.controlView!)

        self.configGesture()

        self.singleTapGesture.require(toFail: self.doubleTapGesture)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension QNPlayerView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool{
        guard  let player = self.player else {
            return false
        }

        if self.singleTapGesture == gestureRecognizer || self.doubleTapGesture == gestureRecognizer{
            if let customAction =  self.controlView as? QNPlayerCustomAction{//点击控制条
                return  !customAction.autohidedControlViews.contains(touch.view!) && !customAction.autohidedControlViews.contains(touch.view!.superview!)
            }
        }else if self.panGesture == gestureRecognizer{
            if player.scrollView != nil && player.indexPath != nil && player.displayMode == .embedded{//嵌入模式且在列表中不支持
                return false
            }

            return touch.view == self.controlView
        }
        return true
    }
}

// MARK: - UIGestureRecognizer
extension QNPlayerView {
    private func configGesture(){
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panDirection(_:)))
        self.addGestureRecognizer(self.panGesture)
        self.panGesture.delegate = self

        self.singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.singleTapGestureTapped(_:)))
        self.singleTapGesture.delegate = self
        self.singleTapGesture.numberOfTapsRequired = 1
        self.singleTapGesture.numberOfTouchesRequired = 1
        self.addGestureRecognizer(self.singleTapGesture)

        self.doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapGestureTapped(_:)))
        self.doubleTapGesture.delegate = self
        self.doubleTapGesture.numberOfTapsRequired = 2
        self.doubleTapGesture.numberOfTouchesRequired = 1
        self.addGestureRecognizer(self.doubleTapGesture)

        self.singleTapGesture.require(toFail: self.doubleTapGesture)
    }

    @objc private func panDirection(_ pan: UIPanGestureRecognizer) {
        guard  let player = self.player else {
            return
        }
        let velocityPoint = pan.velocity(in: self)

        switch pan.state {
        case UIGestureRecognizerState.began:

            let x = fabs(velocityPoint.x)
            let y = fabs(velocityPoint.y)

            if x > y {

                if let horizontalPanDelegate =  self.controlView as? QNPlayerHorizontalPan , player.canSlideProgress{
                    self.isHorizontalPan = true
                    self.position = player.currentTime
                    horizontalPanDelegate.player(player, progressWillChange: self.position ?? 0)
                }

            } else {
                self.isHorizontalPan = false
                if pan.location(in: self).x > self.bounds.size.width / 2 {
                    self.trigger = player.slideTrigger.right
                } else {
                    self.trigger = player.slideTrigger.left
                }
            }
        case UIGestureRecognizerState.changed:
            if self.isHorizontalPan{
                self.horizontalMoved(velocityPoint.x)
            }else{
                self.verticalMoved(velocityPoint.y,player:player, type: self.trigger)
            }
        case UIGestureRecognizerState.ended:
            if self.isHorizontalPan{
                if let horizontalPanDelegate =  self.controlView as? QNPlayerHorizontalPan, player.canSlideProgress{
                    if let position = self.position , !position.isNaN {
                        horizontalPanDelegate.player(player, progressDidChange: position)
                    }
                }
            }
        default:
            break
        }
    }

    @objc private func singleTapGestureTapped(_ sender: UIGestureRecognizer) {
        guard  let player = self.player else {
            return
        }
        if let gestureRecognizer =  self.controlView as? QNPlayerGestureRecognizer{
            gestureRecognizer.player(player, singleTapGestureTapped: sender as! UITapGestureRecognizer )
        }
        NotificationCenter.default.post(name: .QNPlayerTapGestureRecognizer, object: player, userInfo: [Notification.Key.QNPlayerNumberOfTaps: 1, Notification.Key.QNPlayerTapGestureRecognizer: sender as! UITapGestureRecognizer])
    }

    @objc private func doubleTapGestureTapped(_ sender: UIGestureRecognizer) {
        guard  let player = self.player else {
            return
        }
        if let gestureRecognizer =  self.controlView as? QNPlayerGestureRecognizer{
            gestureRecognizer.player(player, doubleTapGestureTapped: sender as! UITapGestureRecognizer )
        }
        NotificationCenter.default.post(name: .QNPlayerTapGestureRecognizer, object: player, userInfo: [Notification.Key.QNPlayerNumberOfTaps: 2,Notification.Key.QNPlayerTapGestureRecognizer: sender  as! UITapGestureRecognizer])
    }

    private func verticalMoved(_ value: CGFloat,player: QNPlayer, type: QNPlayerSlideTrigger) {
        switch type {
        case .volume:
            player.systemVolume -= Float(value / 10000)
        case .brightness:
            UIScreen.main.brightness -= value / 10000
        default:
            break
        }
    }

    private func horizontalMoved(_ value: CGFloat) {
        guard  let player = self.player , let horizontalPanDelegate =  self.controlView as? QNPlayerHorizontalPan ,  player.canSlideProgress else {
            return
        }
        if let position = self.position , !position.isNaN ,let duration = player.duration , !duration.isNaN{

            let nextPosition = position + TimeInterval(value) / 100.0 * (duration/400)

            if nextPosition > duration {
                self.position = duration
            }else if nextPosition < 0 {
                self.position = 0
            }else{
                self.position = nextPosition
            }
            horizontalPanDelegate.player(player, progressChanging: nextPosition)
        }
    }
}
