//
//  WebsiteView.swift
//  Cognostic
//
//  Created by Apollo Zhu on 9/12/20.
//  Copyright © 2020-2021 Cognostic. All rights reserved.
//

import SwiftUI

struct WebsiteView: View {
    let site: String

    let title: LocalizedStringKey
    let description: LocalizedStringKey
    let icon: Image

    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                Text(title)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            icon
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .accessibility(addTraits: .isButton)
                .accessibility(value: Text(site))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if let url = URL(string: self.site) {
                UIApplication.shared.open(url)
            }
        }
    }
}

struct WebsiteView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            WebsiteView(site: "apple.com",
                        title: "Apple",
                        description: "SwiftUI Rocks",
                        icon: Image(systemName: "applelogo"))
        }
    }
}
