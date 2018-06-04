//
//  VideosTableViewController.swift
//  QNPlayerExample
//
//  Created by taoxiaofei on 2018/04/30.
//  Copyright © 2018年 taoxiaofei. All rights reserved.
//

import UIKit

class VideosCell: UITableViewCell {
    
    @IBOutlet weak var perview: UIView!
}

class VideosTableViewController: UITableViewController {
    var index : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "videosIdentifier", for: indexPath)
        cell.selectionStyle = .none
        // Configure the cell...
        cell.textLabel?.text = "the \(indexPath.row) video"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let player = MediaManager.sharedInstance.player  ,let index = player.indexPath , index == indexPath{
           return
        }
        let cell = tableView.cellForRow(at: indexPath) as! VideosCell
        self.index = indexPath
        MediaManager.sharedInstance.playEmbeddedVideo(url:URL.Test.localMP4_0, embeddedContentView: cell.perview)
        MediaManager.sharedInstance.player?.indexPath = indexPath
        MediaManager.sharedInstance.player?.scrollView = tableView
    }

    // MARK: - Rotate
    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .landscape
        }else {
            return .portrait
        }
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .landscapeRight
        }else {
            return .portrait
        }
    }
}
