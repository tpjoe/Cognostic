//
//  HomeView.swift
//  Cognostic
//
//  Created by Apollo Zhu on 9/13/20.
//  Copyright © 2020-2021 Cognostic. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var config: CKPropertyReader
    var color: Color {
        return Color(config.readColor(query: "Primary Color"))
    }

    var body: some View {
        TabView {
            WelcomeNotificationView()
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            
            NavigationView {
                ZStack {
                    Color(UIColor.systemGroupedBackground)
                        .edgesIgnoringSafeArea(.all)

                    StatisticsView(color: color)
                        .navigationBarTitle("Statistics")
                }
            }
            .tabItem {
                Image(systemName: "gauge")
                Text("Statistics")
            }

//            ScheduleViewControllerRepresentable()
//                .tabItem {
//                    Image("tab_schedule").renderingMode(.template)
//                    Text("Schedule")
//                }

//            CareTeamViewControllerRepresentable()
//                .tabItem {
//                    Image("tab_care").renderingMode(.template)
//                    Text("Contact")
//                }

            //            ActivitiesView(color: color)
            //                .tabItem {
            //                    Image("tab_activities")
            //                        .renderingMode(.template)
            //                    Text("Testing Activities")
            //                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }

            SettingsView()
                .tabItem {
                    if #available(iOS 14, *) {
                        Image(systemName: "gearshape")
                    } else {
                        Image(systemName: "gear")
                    }
                    Text("Settings")
                }
        }
        .accentColor(color)
        .environmentObject(NotificationsAndResults.shared)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(CKPropertyReader(file: "CKConfiguration"))
    }
}
