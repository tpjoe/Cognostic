//
//  CurrentDate.swift
//  Cognostic
//
//  Created by Apollo Zhu on 4/5/21.
//  Copyright © 2020-2021 Cognostic. All rights reserved.
//

import SwiftUI

struct CurrentDate: View {
    var body: some View {
        Text(DateFormatter.mediumDate.string(from: Date()))
            .foregroundColor(.accentColor)
    }
}

struct CurrentDate_Previews: PreviewProvider {
    static var previews: some View {
        CurrentDate()
    }
}
