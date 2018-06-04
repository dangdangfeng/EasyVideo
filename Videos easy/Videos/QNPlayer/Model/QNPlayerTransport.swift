//
//  QNPlayerTransport.swift
//  QNPlayer
//
//  Created by taoxiaofei on 2018/04/28.
//  Copyright © 2018年 taoxiaofei. All rights reserved.
//

import Foundation
import UIKit

public protocol QNPlayerHorizontalPan: class {
    func player(_ player: QNPlayer ,progressWillChange value: TimeInterval)
    func player(_ player: QNPlayer ,progressChanging value: TimeInterval)
    func player(_ player: QNPlayer ,progressDidChange value: TimeInterval)
}

public protocol QNPlayerGestureRecognizer: class {
    func player(_ player: QNPlayer ,singleTapGestureTapped singleTap: UITapGestureRecognizer)
    func player(_ player: QNPlayer ,doubleTapGestureTapped doubleTap: UITapGestureRecognizer)
}

public protocol QNPlayerCustomAction:class {
    weak var player: QNPlayer? { get set }
    var autohidedControlViews: [UIView] { get set }

    func playPauseButtonPressed(_ sender: Any)
    func fullEmbeddedScreenButtonPressed(_ sender: Any)
    func closeButtonPressed(_ sender: Any)
}

public protocol QNPlayerCustom: QNPlayerDelegate,QNPlayerCustomAction,QNPlayerHorizontalPan,QNPlayerGestureRecognizer {
}
