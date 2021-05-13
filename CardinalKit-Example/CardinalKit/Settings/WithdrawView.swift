//
//  WithdrawView.swift
//  Cognostic
//
//  Created by Apollo Zhu on 9/12/20.
//  Copyright © 2020-2021 Cognostic. All rights reserved.
//

import SwiftUI

struct WithdrawView: View {
    @State var showWithdraw = false

    var body: some View {
        Button(action: {
            showWithdraw.toggle()
        }, label: {
            if #available(iOS 14.0, *) {
                Label("Withdraw from Study", systemImage: "exclamationmark.triangle")
            } else {
                Text("⚠️ Withdraw from Study")
            }
        })
        .font(Font.body.bold())
        .foregroundColor(.red)
        .sheet(isPresented: $showWithdraw) {
            WithdrawalVC()
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct WithdrawView_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawView()
    }
}
