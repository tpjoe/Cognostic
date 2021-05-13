//
//  StudyTableItem.swift
//
//  Created for the CardinalKit Framework.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import ResearchKit

enum StudyTableItem: Int, CaseIterable {
    // table items
    case survey, trailMakingA, trailMakingB, spatial, speechRecognition, amslerGrid, reaction, tower, psat, stroop, nine, tone

    var task: ORKOrderedTask {
        switch self {
        case .survey:
            return StudyTasks.survey
        case .trailMakingA:
            return StudyTasks.trailMakingA
        case .trailMakingB:
            return StudyTasks.trailMakingB
        case .spatial:
            return StudyTasks.spatial
        case .speechRecognition:
            return StudyTasks.speechRecognition
        case .amslerGrid:
            return StudyTasks.amslerGrid
        case .reaction:
            return StudyTasks.reaction
        case .tower:
            return StudyTasks.tower
        case .psat:
            return StudyTasks.psat
        case .stroop:
            return StudyTasks.stroop
        case .nine:
            return StudyTasks.nine
        case .tone:
            return StudyTasks.tone
        }
    }

    var title: String {
        switch self {
        case .survey:
            return "Patient Survey"
        case .trailMakingA:
            return "Trail Making A"
        case .trailMakingB:
            return "Trail Making B"
        case .spatial:
            return "Spatial Memory"
        case .speechRecognition:
            return "Speech Recognition"
        case .amslerGrid:
            return "Amsler Grid"
        case .reaction:
            return "Reaction Time"
        case .tower:
            return "Tower of Hanoi"
        case .psat:
            return "PSAT"
        case .stroop:
            return "Stroop Test"
        case .nine:
            return "9-Hole Peg"
        case .tone:
            return "Tone Audiometry"
        }
    }

    var subtitle: String {
        switch self {
        case .survey:
            return "Survey of basic health information"
        case .trailMakingA:
            return "This activity evaluates your visual activity and task"
        case .trailMakingB:
            return "This activity evaluates your visual activity and task"
        case .spatial:
            return "This activity measures your short term spacial memory"
        case .speechRecognition:
            return "This activity records your speech"
        case .amslerGrid:
            return "This activity helps with detecting problems in your vision"
        case .reaction:
            return "This activity evaluates your reaction speed"
        case .tower:
            return "This activity measures your problem solving skills."
        case .psat:
            return "This activity measures your cognitive function that assesses auditory and/or visual information processing speed, flexibility, and the calculation ability"
        case .stroop:
            return "This activity assesses your cognitive responsive ability"
        case .nine:
            return "This activity of hand dexterity measures your MSFC score in Multiple Sclerosis, or signs of Parkinson’s disease or stroke"
        case .tone:
            return "This activity measures different properties of your hearing ability, based on your reaction to a wide range of frequencies"
        }
    }

    var image: Image? {
        switch self {
        case .survey:
            return Image(systemName: "doc.plaintext")
        case .trailMakingA, .trailMakingB:
            if #available(iOS 14, *) {
                return Image(systemName: "point.fill.topleft.down.curvedto.point.fill.bottomright.up")
            } else {
                return Image(systemName: "scribble")
            }
        case .spatial:
            if #available(iOS 14, *) {
                return Image(systemName: "square.grid.3x3.middleright.fill")
            } else {
                return Image(systemName: "circle.grid.3x3")
            }
        case .speechRecognition:
            if #available(iOS 14, *) {
                return Image(systemName: "rectangle.3.offgrid.bubble.left")
            } else {
                return Image(systemName: "mic")
            }
        case .amslerGrid:
            if #available(iOS 14, *) {
                return Image(systemName: "dot.squareshape.split.2x2")
            } else {
                return Image(systemName: "dot.square")
            }
        case .reaction:
            return systemImage(iOS14Name: "clock", iOS13Name: "clock")
        case .tower:
            return systemImage(iOS14Name: "tray.2", iOS13Name: "tray.2")
        case .psat:
            return systemImage(iOS14Name: "plus.diamond.fill", iOS13Name: "plus.diamond.fill")
        case .stroop:
            return systemImage(iOS14Name: "textformat.abc.dottedunderline", iOS13Name: "textformat.abc.dottedunderline")
        case .nine:
            return systemImage(iOS14Name: "hand.point.up.braille.fill", iOS13Name: "hand.point.up.braille.fill")
        case .tone:
            return systemImage(iOS14Name: "ear.fill", iOS13Name: "ear.fill")
        }
        
    }
}
