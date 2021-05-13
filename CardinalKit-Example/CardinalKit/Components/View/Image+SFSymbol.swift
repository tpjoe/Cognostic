//
//  Image+SFSymbol.swift
//  Cognostic
//
//  Created by Apollo Zhu on 4/6/21.
//  Copyright © 2020-2021 Cognostic. All rights reserved.
//

import SwiftUI

func systemImage(iOS14Name: String, iOS13Name: String) -> Image {
    if #available(iOS 14, *) {
        return Image(systemName: iOS14Name)
    } else {
        return Image(systemName: iOS13Name)
    }
}
