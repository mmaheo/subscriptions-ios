//
//  Logger+App.swift
//  Subscriptions
//
//  Created by Maxime Maheo on 17/02/2021.
//

import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let realm = Logger(subsystem: subsystem, category: "realm")
    static let userAction = Logger(subsystem: subsystem, category: "userAction")
}
