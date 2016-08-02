//
//  FileHelper.swift
//  PlayListPlayer
//
//  Created by Kohei Tabata on 2016/08/02.
//  Copyright © 2016年 nerd0geek1. All rights reserved.
//

import Foundation

class FileHelper {
    class func audio1URL() -> NSURL! {
        return fileURLFor("sample_audio1", fileExtension: "mp3")
    }

    class func audio2URL() -> NSURL! {
        return fileURLFor("sample_audio2", fileExtension: "mp3")
    }

    class func movie1URL() -> NSURL! {
        return fileURLFor("sample_movie", fileExtension: "mp4")
    }

    private class func fileURLFor(baseName: String, fileExtension: String) -> NSURL! {
        return NSBundle.init(forClass: self).URLForResource(baseName, withExtension: fileExtension)
    }
}
