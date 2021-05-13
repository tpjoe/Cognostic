//
//  StudyItem.swift
//  Cognostic
//
//  Created by Apollo Zhu on 9/13/20.
//  Copyright © 2020-2021 Cognostic. All rights reserved.
//

import ResearchKit
import SwiftUI

struct StudyItem: Identifiable {
    let id = UUID()
    let image: Image
    let title: String
    let description: String
    let task: ORKOrderedTask

    init(study: StudyTableItem) {
        self.image = study.image!
        self.title = study.title
        self.description = study.subtitle
        self.task = study.task
    }
}
