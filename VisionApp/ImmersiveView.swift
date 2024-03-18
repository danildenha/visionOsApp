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
    @State var characterEntity: Entity = {
            let headAnchor = AnchorEntity(.head)
            headAnchor.position = [0.70, -0.35, -1]
            let radians = 10 * Float.pi / 180
            ImmersiveView.rotateEntityAroundYAxis(entity: headAnchor, angle: radians)
            return headAnchor
        }()
    
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            do {
                // identify root
                let immersiveEntity = try await Entity(named: "Immersive",
                                                       in: realityKitContentBundle)
                characterEntity.addChild(immersiveEntity)
                content.add(characterEntity)
            } catch {
                print("Error in RealityView's Make \(error)")
            }
        } 
    }
    static func rotateEntityAroundYAxis(entity: Entity, angle: Float) {
            // Get the current transform of the entity
            var currentTransform = entity.transform

            // Create a quaternion representing a rotation around the Y-axis
            let rotation = simd_quatf(angle: angle, axis: [0, 1, 0])

            // Combine the rotation with the current transform
            currentTransform.rotation = rotation * currentTransform.rotation

            // Apply the new transform to the entity
            entity.transform = currentTransform
        }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
