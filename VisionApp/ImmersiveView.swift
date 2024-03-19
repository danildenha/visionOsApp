//
//  ImmersiveView.swift
//  VisionApp
//
//  Created by Danil Denha on 2/19/24.
//

import Combine
import RealityKit
import SwiftUI

import AVFoundation
import RealityKitContent

struct ImmersiveView: View {
    
    var body: some View {
        RealityView { content in
            let immersiveEntity = try await Entity(named: "Immersive",
                                                       in: realityKitContentBundle)
            }
        }
    }

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
