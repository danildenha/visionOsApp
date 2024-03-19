//
//  VisionAppApp.swift
//  VisionApp
//
//  Created by Danil Denha on 2/19/24.
//

import SwiftUI

@main
struct VisionAppApp: App {
    @State private var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }
        .windowStyle(.plain)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
                .environment(viewModel)
        }
    }
}
