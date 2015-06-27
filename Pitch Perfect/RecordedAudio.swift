//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by A. Anthony Castillo on 6/26/15.
//  Copyright (c) 2015 Alon Consulting, Inc. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject
{    
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title:String)
    {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}