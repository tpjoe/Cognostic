//
//  LaunchContainerView.swift
//  Cognostic
//
//  Created by Apollo Zhu on 9/12/20.
//  Copyright © 2020-2021 Cognostic. All rights reserved.
//

import SwiftUI

struct LaunchContainerView: View {
    @State var showHomeScreen: Bool = false

    var body: some View {
        Group{
            if showHomeScreen {
                HomeView()
            } else {
                OnboardingUI()
                    .transition(.slide)
            }
        }
        .onReceive(UserDefaults.standard.publisher(for: \.showHomeScreen))
        { shouldShowHomeScreen in
            withAnimation {
                self.showHomeScreen = shouldShowHomeScreen
            }
        }
    }
}

struct LaunchContainerView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchContainerView()
    }
}
