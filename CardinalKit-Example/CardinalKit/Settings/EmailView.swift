//
//  EmailView.swift
//  Cognostic
//
//  Created by Apollo Zhu on 9/12/20.
//  Copyright © 2020-2021 Cognostic. All rights reserved.
//

import SwiftUI

struct EmailView: View {
    let title: String
    let email: String

    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                Text(title)
                Text("Send feedback or ask for app support")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "envelope")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .accessibility(addTraits: .isButton)
                .accessibility(value: Text(email))
        }
        .onTapGesture {
            EmailHelper.shared
                .sendEmail(subject: self.email,
                           body: "Regarding Cognostic, ",
                           to: "Enter your question/support request here.")
        }
    }
}

struct EmailView_Previews: PreviewProvider {
    static var previews: some View {
        EmailView(title: "Email", email: "test@uwdev.app")
    }
}
