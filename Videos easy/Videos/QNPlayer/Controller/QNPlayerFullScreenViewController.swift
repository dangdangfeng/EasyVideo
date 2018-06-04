//
//  QNFullScreenViewController.swift
//  QNPlayer
//
//  Created by taoxiaofei on 2018/04/28.
//  Copyright © 2018年 taoxiaofei. All rights reserved.
//

import UIKit

open class QNPlayerFullScreenViewController: UIViewController {
    weak  var player: QNPlayer!
    private var statusbarBackgroundView: UIView!
    public var preferredlandscapeForPresentation = UIInterfaceOrientation.landscapeLeft
    public var currentOrientation = UIDevice.current.orientation

    // MARK: - Life cycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerControlsHiddenDidChange(_:)), name: NSNotification.Name.QNPlayerControlsHiddenDidChange, object: nil)

        self.view.backgroundColor = UIColor.black

        self.statusbarBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: UIApplication.shared.statusBarFrame.size.height))
        self.statusbarBackgroundView.backgroundColor = self.player.fullScreenStatusbarBackgroundColor
        self.statusbarBackgroundView.autoresizingMask = [ .flexibleWidth,.flexibleLeftMargin,.flexibleRightMargin,.flexibleBottomMargin]
        self.view.addSubview(self.statusbarBackgroundView)
    }

    // MARK: - Orientations
    override open var shouldAutorotate : Bool {
        return true
    }

    override open var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        switch self.player.fullScreenMode {
        case .portrait:
            return [.portrait]
        case .landscape:
            return [.landscapeLeft,.landscapeRight]
        }
    }

    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        self.currentOrientation = preferredlandscapeForPresentation == .landscapeLeft ? .landscapeRight : .landscapeLeft

        switch self.player.fullScreenMode {
        case .portrait:
            self.currentOrientation = .portrait
            return .portrait
        case .landscape:
            self.statusbarBackgroundView.isHidden = QNPlayerUtils.isPhoneX
            return self.preferredlandscapeForPresentation
        }
    }

    // MARK: - status bar
    private var statusBarHiddenAnimated = true

    override open var prefersStatusBarHidden: Bool{
        if self.statusBarHiddenAnimated {
            UIView.animate(withDuration: QNPlayerAnimatedDuration, animations: {
                self.statusbarBackgroundView.alpha = self.player.controlsHidden ? 0 : 1
            }, completion: {finished in
            })
        }else{
            self.statusbarBackgroundView.alpha = self.player.controlsHidden ? 0 : 1
        }

        return self.player.controlsHidden
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle{
        return self.player.fullScreenPreferredStatusBarStyle
    }

    // MARK: - notification
    @objc func playerControlsHiddenDidChange(_ notifiaction: Notification) {
        self.statusBarHiddenAnimated = notifiaction.userInfo?[Notification.Key.QNPlayerControlsHiddenDidChangeByAnimatedKey] as? Bool ?? true
        self.setNeedsStatusBarAppearanceUpdate()
        if #available(iOS 11.0, *) {
            self.setNeedsUpdateOfHomeIndicatorAutoHidden()
        }
    }

    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.currentOrientation = UIDevice.current.orientation
    }

    open override func prefersHomeIndicatorAutoHidden() -> Bool {
        return self.player.controlsHidden
    }
}
