//
//  VisionAppApp.swift
//  VisionApp
//
//  Created by Danil Denha on 2/19/24.
//

import SwiftUI

@main
struct VisionAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
