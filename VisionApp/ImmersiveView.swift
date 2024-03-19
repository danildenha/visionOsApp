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
    @Environment(ViewModel.self) private var viewModel
    @State private var inputText = ""
    @State public var showTextField = false
    @State public var showAttachmentButtons = false
    @State var characterEntity: Entity = {
            let headAnchor = AnchorEntity(.head)
            headAnchor.position = [0.70, -0.35, -1]
            let radians = 10 * Float.pi / 180
            ImmersiveView.rotateEntityAroundYAxis(entity: headAnchor, angle: radians)
            return headAnchor
        }()
    
    var body: some View {
        RealityView { content, attachments in
            content.add(Entity())
            // Add the initial RealityKit content
            do {
                // identify root
                let immersiveEntity = try await Entity(named: "Immersive",
                                                       in: realityKitContentBundle)
                characterEntity.addChild(immersiveEntity)
                content.add(characterEntity)
                
                // attachments
                guard let attachmentEntity = attachments.entity(for: "red_e") else { return }
                attachmentEntity.position = SIMD3<Float>(0, 0.62, 0)
                let radians = 30 * Float.pi / 180
                ImmersiveView.rotateEntityAroundYAxis(entity: attachmentEntity, angle: radians)
                characterEntity.addChild(attachmentEntity)
            } catch {
                print("Error in RealityView's Make \(error)")
            }
        } attachments: {
            Attachment(id: "attachments") {
                VStack {
                    Text("heyyyy")
                        .frame(maxWidth: 600, alignment: .leading)
                        .font(.extraLargeTitle2)
                        .fontWeight(.regular)
                        .padding(40)
                        .glassBackgroundEffect()
                }
                .tag("attachment")
                .opacity(showTextField ? 1 : 0)
            }
        }
        .gesture(SpatialTapGesture().targetedToAnyEntity().onEnded {
            _ in
            viewModel.flowState = .intro
        })
        .onChange(of: viewModel.flowState) { _, newValue in
            switch newValue {
            case .idle:
                break
            case.intro:
                playIntro();
            case .projectileFlying:
                break
            case .updateWallArt:
                break
            }
        }
    }
    
    func playIntro() {

        Task {
            // show dialog box
            if !showTextField {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showTextField.toggle()
                }
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
