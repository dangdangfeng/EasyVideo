//
//  Utils.swift
//  QNPlayerExample
//
//  Created by taoxiaofei on 2018/04/30.
//  Copyright © 2018年 taoxiaofei. All rights reserved.
//

import Foundation
extension URL {
    struct Test {
        //local
        static let localMP4_0 =  Bundle.main.url(forResource: "hubblecast", withExtension: "m4v")!
        static let localMP4_1 =  Bundle.main.url(forResource: "Charlie The Unicorn", withExtension: "m4v")!
        static let localMP4_2 =  Bundle.main.url(forResource: "blackhole", withExtension: "mp4")!

        //remote vod
        static let apple_0 = URL(string: "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8")!
        static let apple_1 = URL(string: "https://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8")!

        static let remoteMP4_0 =  URL(string: "http://vjs.zencdn.net/v/oceans.mp4")!
        static let remoteMP4_1 =  URL(string: "http://ali.cdn.kaiyanapp.com/ca41515acf967fc06249c1a16a16f466_1280x720_854x480.mp4?auth_key=1527578810-0-0-8f5fb011405bed3afd791ab788d121f9")!

        static let remoteM3U8_0 =  URL(string: "http://www.streambox.fr/playlists/x36xhzz/url_6/193039199_mp4_h264_aac_hq_7.m3u8")!



        //live
        static let live_0 = URL(string: "https://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8")!



    }
}
