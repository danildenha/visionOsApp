//
//  ViewModel.swift
//  VisionApp
//
//  Created by Danil Denha on 3/18/24.
//

import Foundation
import Observation
import SwiftUI

enum FlowState {
    case idle
    case intro
    case projectileFlying
    case updateWallArt
}

@Observable
class ViewModel {
    var flowState = FlowState.idle
}
