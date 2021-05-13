//
//  List+GroupedStyle.swift
//  Cognostic
//
//  Created by Apollo Zhu on 4/6/21.
//  Copyright © 2020-2021 Cognostic. All rights reserved.
//

import SwiftUI

extension View {
    func withSomeGroupedListStyle() -> some View {
        Group {
            if #available(iOS 14.0, *) {
                self
                    .listStyle(InsetGroupedListStyle())
            } else {
                self
                    .listStyle(GroupedListStyle())
            }
        }
    }
}
