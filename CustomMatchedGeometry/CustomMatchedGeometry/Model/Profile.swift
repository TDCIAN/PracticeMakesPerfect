//
//  Profile.swift
//  CustomMatchedGeometry
//
//  Created by 김정민 on 2023/09/06.
//

import SwiftUI

/// Profile Model With Sample Data
/// Reference: https://unsplash.com
struct Profile: Identifiable {
    var id = UUID().uuidString
    var userName: String
    var profilePicture: String
    var lastMsg: String
    var lastActive: String
    
}

var profiles = [
    Profile(userName: "iJustine", profilePicture: "dog1", lastMsg: "Hi Kavsoft!!!", lastActive: "10:25 PM"),
    Profile(userName: "Jenna Ezarik", profilePicture: "dog2", lastMsg: "Nothing!!!", lastActive: "06:25 PM"),
    Profile(userName: "Emily", profilePicture: "dog3", lastMsg: "Binge Watching...", lastActive: "10:25 PM"),
    Profile(userName: "Julie", profilePicture: "dog4", lastMsg: "404 Page not Found!", lastActive: "10:25 PM"),
    Profile(userName: "Kaviya", profilePicture: "dog5", lastMsg: "Do not Disturb", lastActive: "10:25 PM")
]
