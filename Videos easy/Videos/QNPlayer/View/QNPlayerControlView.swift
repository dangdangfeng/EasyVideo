//
//  QNPlayerControlView.swift
//  QNPlayer
//
//  Created by taoxiaofei on 2018/04/28.
//  Copyright © 2018年 taoxiaofei. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

open class QNPlayerControlView: UIView{
    weak public var player: QNPlayer?{
        didSet{
            player?.setControlsHidden(false, animated: true)
            self.autohideControlView()
        }
    }

    var hideControlViewTask: Task?

    public var autohidedControlViews = [UIView]()
    
    // 顶部
    var navBarContainer: UIView = {
        let view = UIView()
        return view
    }()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.contentMode = .top
        return label
    }()
    
    var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.addTarget(self, action: #selector(closeButtonPressed(_:)), for: .touchUpInside)
        closeButton.setImage(UIImage(named: "qn_news_player_close", in: Bundle(for: QNPlayerControlView.self), compatibleWith: nil), for: .normal)
        return closeButton
    }()
    
    // 底部
    var toolBarContainer: UIView = {
       let view = UIView()
        return view
    }()
    
    var playPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "qn_news_player_play_button", in: Bundle(for: QNPlayerControlView.self), compatibleWith: nil), for: .normal)
        button.addTarget(self, action: #selector(playPauseButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    var timeLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.contentMode = .right
        label.textAlignment = .right
        label.text = "00:00/00:00"
        return label
    }()
    var fullEmbeddedScreenButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "qn_news_player_fullscreen_enter", in: Bundle(for: QNPlayerControlView.self), compatibleWith: nil), for: .normal)
        button.addTarget(self, action: #selector(fullEmbeddedScreenButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    var progressView: UIProgressView = {
        let progress = UIProgressView()
        progress.progressTintColor = UIColor.init(qnhex: 0xFFFF20)
        progress.trackTintColor = UIColor.init(qnhex: 0x000000)
        progress.progress = 0.5
        return progress
    }()
    var timeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.setThumbImage(UIImage(named: "qn_news_player_progress", in: Bundle(for: QNPlayerControlView.self), compatibleWith: nil), for: UIControlState.normal)
        slider.addTarget(self, action: #selector(progressSliderTouchEnd(_:)), for: .touchUpInside)
        slider.addTarget(self, action: #selector(progressSliderTouchEnd(_:)), for: .touchCancel)
        slider.addTarget(self, action: #selector(progressSliderTouchBegan(_:)), for: .touchDown)
        slider.addTarget(self, action: #selector(progressSliderTouchEnd(_:)), for: .touchUpOutside)
        slider.addTarget(self, action: #selector(progressSliderValueChanged(_:)), for: .valueChanged)
        return slider
    }()
    
    // 预览
    var videoshotPreview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.isOpaque = true
        return view
    }()
    var videoshotImageView: UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFit
        return imgV
    }()
    
    // 加载
    var loading: QNPlayerLoading = {
        let load = QNPlayerLoading()
        load.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return load
    }()

    //中间播放按钮
    var centerPlayPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "qn_news_player_play_center", in: Bundle(for: QNPlayerControlView.self), compatibleWith: nil), for: .normal)
        button.addTarget(self, action: #selector(playPauseButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life cycle
    open override func layoutSubviews() {
        super.layoutSubviews()

        // 顶部
        navBarContainer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 75)
        
        let titleH = titleLabel.text?.qntextSize(withFont: UIFont.systemFont(ofSize: 17)).height ?? 0
        if self.player?.displayMode == .fullscreen {
            closeButton.frame = CGRect(x: 16, y: 0, width: 36, height: 36)
            titleLabel.frame = CGRect(x: 16+36, y: 16, width: self.bounds.size.width - 16 - 36, height: titleH)
            closeButton.center.y = timeLabel.center.y + 2
        }else{
            closeButton.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            titleLabel.frame = CGRect(x: 16, y: 16, width: self.bounds.size.width - 16, height: titleH)
        }
        
        // 底部
        toolBarContainer.frame = CGRect(x: 0, y: self.bounds.size.height - 50 , width: self.bounds.size.width, height: 50)
        playPauseButton.frame = CGRect(x: 8, y: 7, width: 36, height: 36)
        
        progressView.frame = CGRect(x: 8 + 38, y: 24, width: toolBarContainer.bounds.size.width - 36 - 75 - 36 - 16, height: 2)
        timeSlider.frame = CGRect(x: 8 + 36, y: 19, width: progressView.frame.size.width + 4, height: 12)
        
        timeLabel.frame = CGRect(x: toolBarContainer.bounds.size.width - 36 - 8 - 75, y: 15, width: 75, height: 21)
        fullEmbeddedScreenButton.frame = CGRect(x: toolBarContainer.bounds.size.width - 36 - 8, y: 7, width: 36, height: 36)
    
        // 预览
        videoshotPreview.frame = CGRect(x: 53, y: self.bounds.size.height - toolBarContainer.bounds.size.height - 60, width: 106, height: 60)
        videoshotImageView.frame = CGRect(x: 0, y: 0, width: videoshotPreview.frame.width, height: videoshotPreview.frame.height)
        
        // 中间播放按钮
        centerPlayPauseButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        centerPlayPauseButton.center = self.center
        
        // 加载
        loading.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        loading.center = self.center
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.timeSlider.value = 0
        self.progressView.progress = 0
        self.progressView.progressTintColor = UIColor.lightGray
        self.progressView.trackTintColor = UIColor.clear
        self.progressView.backgroundColor = UIColor.clear
        
        self.videoshotPreview.isHidden = true
        self.autohidedControlViews = [self.navBarContainer,self.toolBarContainer,self.centerPlayPauseButton]
        
        addViews()
    }
    
    private func addViews() {
        self.addSubview(navBarContainer)
        self.addSubview(toolBarContainer)
        self.addSubview(videoshotPreview)
        self.addSubview(centerPlayPauseButton)
        self.addSubview(loading)
        
        // 头部
        navBarContainer.addSubview(closeButton)
        navBarContainer.addSubview(titleLabel)
        
        // 底部
        toolBarContainer.addSubview(playPauseButton)
        toolBarContainer.addSubview(fullEmbeddedScreenButton)
        toolBarContainer.addSubview(timeLabel)
        toolBarContainer.addSubview(progressView)
        toolBarContainer.addSubview(timeSlider)
        
        //预览
        videoshotPreview.addSubview(videoshotImageView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - QNPlayerCustomControlView

    fileprivate var isProgressSliderSliding = false

    @objc func progressSliderTouchBegan(_ sender: Any) {
        guard let player = self.player else {
            return
        }
        self.player(player, progressWillChange: TimeInterval(self.timeSlider.value))
    }

    @objc func progressSliderValueChanged(_ sender: Any) {
        guard let player = self.player else {
            return
        }

        self.player(player, progressChanging: TimeInterval(self.timeSlider.value))

        if !player.isM3U8 {
            self.videoshotPreview.isHidden = false
            player.generateThumbnails(times:  [ TimeInterval(self.timeSlider.value)],maximumSize:CGSize(width: self.videoshotImageView.bounds.size.width, height: self.videoshotImageView.bounds.size.height)) { (thumbnails) in
                let trackRect = self.timeSlider.convert(self.timeSlider.bounds, to: nil)
                let thumbRect = self.timeSlider.thumbRect(forBounds: self.timeSlider.bounds, trackRect: trackRect, value: self.timeSlider.value)
                var lead = thumbRect.origin.x + thumbRect.size.width/2 - self.videoshotPreview.bounds.size.width/2
                if lead < 0 {
                    lead = 0
                }else if lead + self.videoshotPreview.bounds.size.width > player.view.bounds.width {
                    lead = player.view.bounds.width - self.videoshotPreview.bounds.size.width
                }
                let frame = self.videoshotPreview.frame
                self.videoshotPreview.frame = CGRect(x: lead, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
                self.videoshotImageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
                if thumbnails.count > 0 {
                    let thumbnail = thumbnails[0]
                    if thumbnail.result == .succeeded {
                        self.videoshotImageView.image = thumbnail.image
                    }
                }
            }
        }
    }

    @objc func progressSliderTouchEnd(_ sender: Any) {
        self.videoshotPreview.isHidden = true
        guard let player = self.player else {
            return
        }
        self.player(player, progressDidChange: TimeInterval(self.timeSlider.value))
    }

    fileprivate func hideControlView(_ animated: Bool) {
        if animated{
            UIView.setAnimationsEnabled(false)
            UIView.animate(withDuration: QNPlayerAnimatedDuration, delay: 0,options: .curveEaseInOut, animations: {
                self.autohidedControlViews.forEach{
                    $0.alpha = 0
                }
            }, completion: {finished in
                self.autohidedControlViews.forEach{
                    $0.isHidden = true
                }
                UIView.setAnimationsEnabled(true)
            })
        }else{
            self.autohidedControlViews.forEach{
                $0.alpha = 0
                $0.isHidden = true
            }
        }
    }

    fileprivate func showControlView(_ animated: Bool) {
        if animated{
            UIView.setAnimationsEnabled(false)
            self.autohidedControlViews.forEach{
                $0.isHidden = false
            }
            UIView.animate(withDuration: QNPlayerAnimatedDuration, delay: 0,options: .curveEaseInOut, animations: {
                if self.player?.displayMode == .fullscreen{
                    self.navBarContainer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 40)
                    self.toolBarContainer.frame = CGRect(x: 0, y: self.bounds.size.height - 50 , width: self.bounds.size.width, height: 50)
                }else{
                    self.navBarContainer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 40)
                    self.toolBarContainer.frame = CGRect(x: 0, y: self.bounds.size.height - 50 , width: self.bounds.size.width, height: 50)
                }
                self.autohidedControlViews.forEach{
                    $0.alpha = 1
                }
            }, completion: {finished in
                self.autohideControlView()
                UIView.setAnimationsEnabled(true)
            })
        }else{
            self.autohidedControlViews.forEach{
                $0.isHidden = false
                $0.alpha = 1
            }
            if self.player?.displayMode == .fullscreen{
                navBarContainer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 40)
                toolBarContainer.frame = CGRect(x: 0, y: self.bounds.size.height - 50 , width: self.bounds.size.width, height: 50)
            }else{
                navBarContainer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 40)
            }
            self.autohideControlView()
        }
    }

    fileprivate func autohideControlView(){
        guard let player = self.player , player.autohiddenTimeInterval > 0 else {
            return
        }
        cancel(self.hideControlViewTask)
        self.hideControlViewTask = delay(5, task: { [weak self]  in
            guard let weakSelf = self else {
                return
            }
            weakSelf.player?.setControlsHidden(true, animated: true)
        })
    }
}

extension QNPlayerControlView: QNPlayerCustom {
    // MARK: - QNPlayerCustomAction
    @objc public func playPauseButtonPressed(_ sender: Any) {
        guard let player = self.player else {
            return
        }
        if player.isPlaying {
            player.pause()
        }else{
            player.play()
        }
    }

    @objc public func fullEmbeddedScreenButtonPressed(_ sender: Any) {
        guard let player = self.player else {
            return
        }
        switch player.displayMode {
        case .embedded:
            player.toFull()
        case .fullscreen:
            if player.lastDisplayMode == .embedded{
                player.toEmbedded()
            }
        default:
            break
        }
    }

    @objc public func closeButtonPressed(_ sender: Any) {
        guard let player = self.player else {
            return
        }
        let displayMode = player.displayMode
        if displayMode == .fullscreen {
            if player.lastDisplayMode == .embedded{
                player.toEmbedded()
            }
        }
        player.closeButtonBlock?(.embedded)// 直接关闭了
    }

    // MARK: - QNPlayerGestureRecognizer
    public func player(_ player: QNPlayer, singleTapGestureTapped singleTap: UITapGestureRecognizer) {
        player.setControlsHidden(!player.controlsHidden, animated: true)
    }

    public func player(_ player: QNPlayer, doubleTapGestureTapped doubleTap: UITapGestureRecognizer) {
        self.playPauseButtonPressed(doubleTap)
    }

    // MARK: - QNPlayerHorizontalPan
    public func player(_ player: QNPlayer, progressWillChange value: TimeInterval) {
        if player.isLive ?? true{
          return
        }
        cancel(self.hideControlViewTask)
        self.isProgressSliderSliding = true
    }

    public func player(_ player: QNPlayer, progressChanging value: TimeInterval) {
        if player.isLive ?? true{
            return
        }
        self.timeLabel.text = QNPlayerUtils.formatTime(position: value, duration: self.player?.duration ?? 0)
        if !self.timeSlider.isTracking {
            self.timeSlider.value = Float(value)
        }
    }

    public func player(_ player: QNPlayer, progressDidChange value: TimeInterval) {
        if player.isLive ?? true{
            return
        }
        self.autohideControlView()
        self.player?.seek(to: value, completionHandler: { (isFinished) in
            self.isProgressSliderSliding = false
        })
    }

    // MARK: - QNPlayerDelegate

    public func playerHeartbeat(_ player: QNPlayer) {
    }

    public func player(_ player: QNPlayer, playerDisplayModeDidChange displayMode: QNPlayerDisplayMode) {
        switch displayMode {
        case .none:
            break
        case .embedded:
            fullEmbeddedScreenButton.frame = CGRect(x: toolBarContainer.bounds.size.width - 36, y: 7, width: 36, height: 36)
            self.fullEmbeddedScreenButton.setImage(UIImage(named: "qn_news_player_fullscreen_enter", in: Bundle(for: QNPlayerControlView.self), compatibleWith: nil), for: .normal)
        case .fullscreen:
            fullEmbeddedScreenButton.frame = CGRect(x: toolBarContainer.bounds.size.width - 36, y: 7, width: 36, height: 36)
            self.fullEmbeddedScreenButton.setImage(UIImage(named: "qn_news_player_fullscreen_exit", in: Bundle(for: QNPlayerControlView.self), compatibleWith: nil), for: .normal)
            if player.lastDisplayMode == .none{
                fullEmbeddedScreenButton.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            }
            
            if player.state == .pause{
                self.playPauseButton.setImage(UIImage(named: "qn_news_player_play_button", in: Bundle(for: QNPlayerControlView.self), compatibleWith: nil), for: .normal)
                self.centerPlayPauseButton.setImage(UIImage(named: "qn_news_player_play_center", in: Bundle(for: QNPlayerControlView.self), compatibleWith: nil), for: .normal)
            }
        }
    }

    public func player(_ player: QNPlayer, playerStateDidChange state: QNPlayerState) {
        //播放器按钮状态
        switch state {
        case .playing ,.buffering:
            //播放状态
            //            self.playPauseButton.isSelected = true //暂停按钮
            self.playPauseButton.setImage(UIImage(named: "qn_news_player_pause_button", in: Bundle(for: QNPlayerControlView.self), compatibleWith: nil), for: .normal)
            self.centerPlayPauseButton.setImage(UIImage(named: "qn_news_player_pause_center", in: Bundle(for: QNPlayerControlView.self), compatibleWith: nil), for: .normal)
        case .seekingBackward ,.seekingForward:
            break
        default:
            //            self.playPauseButton.isSelected = false // 播放按钮
            self.playPauseButton.setImage(UIImage(named: "qn_news_player_play_button", in: Bundle(for: QNPlayerControlView.self), compatibleWith: nil), for: .normal)
            self.centerPlayPauseButton.setImage(UIImage(named: "qn_news_player_play_center", in: Bundle(for: QNPlayerControlView.self), compatibleWith: nil), for: .normal)
        }
    }

    public func player(_ player: QNPlayer, bufferDurationDidChange bufferDuration: TimeInterval, totalDuration: TimeInterval) {
        if totalDuration.isNaN || bufferDuration.isNaN || totalDuration == 0 || bufferDuration == 0{
            self.progressView.progress = 0
        }else{
        self.progressView.progress = Float(bufferDuration/totalDuration)
        }
    }

    public func player(_ player: QNPlayer, currentTime: TimeInterval, duration: TimeInterval) {
        if currentTime.isNaN || (currentTime == 0 && duration.isNaN){
            return
        }
        self.timeSlider.isEnabled = !duration.isNaN
        self.timeSlider.minimumValue = 0
        self.timeSlider.maximumValue = duration.isNaN ? Float(currentTime) : Float(duration)
        self.titleLabel.text = player.contentItem?.title ?? player.playerasset?.title
        let titleH = titleLabel.text?.qntextSize(withFont: UIFont.systemFont(ofSize: 17)).height ?? 0
        titleLabel.frame = self.player?.displayMode == .fullscreen ? CGRect(x: 16+36, y: 16, width: self.bounds.size.width - 16 - 36, height: titleH) : CGRect(x: 16, y: 16, width: self.bounds.size.width - 16, height: titleH)
        if !self.isProgressSliderSliding {
            self.timeSlider.value = Float(currentTime)
            self.timeLabel.text = duration.isNaN ? "Live" : QNPlayerUtils.formatTime(position: currentTime, duration: duration)
        }
    }

    public func player(_ player: QNPlayer, playerControlsHiddenDidChange controlsHidden: Bool, animated: Bool) {
        if controlsHidden {
            self.hideControlView(animated)
        }else{
            self.showControlView(animated)
        }
    }

    public func player(_ player: QNPlayer ,showLoading: Bool){
        if showLoading {
            self.loading.start()
        }else{
            self.loading.stop()
        }
    }
}
