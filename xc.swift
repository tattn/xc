//
//  xc.swift
//  xc
//
//  Created by Tatsuya Tanaka on 2016/12/29.
//  Copyright © 2016年 tattn. All rights reserved.
//

import Foundation
import AppKit

struct Project {
    enum `Type`: String {
        case xcodeproj
        case xcworkspace
    }

    private let fileName: String
    private var type: Type

    var priority: Int {
        switch type {
        case .xcworkspace: return 1
        case .xcodeproj:   return 2
        }
    }

    init?(fileName: String) {
        guard let type = Type(rawValue: NSString(string: fileName).pathExtension) else {
            return nil
        }

        self.fileName = fileName
        self.type     = type
    }

    func open() {
        NSWorkspace.shared().open(URL(fileURLWithPath: fileName))
    }
}

let project = try! FileManager.default.contentsOfDirectory(atPath: "./")
    .flatMap { Project(fileName: $0) }
    .sorted { $0.0.priority < $0.1.priority }
    .first

if let project = project {
    project.open()
} else {
    print("Xcode project file is not found...")
}

