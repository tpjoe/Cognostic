//
//  WelcomeNotificationView.swift
//  Cognostic
//
//  Created by Lucas Wang on 2020-09-12.
//  Copyright © 2020-2021 Cognostic. All rights reserved.
//

import SwiftUI
import CareKitStore
import CareKitUI

struct WelcomeNotificationView: View {
    @EnvironmentObject var data: NotificationsAndResults
    @State private var showingTestDetail = false
    @State private var currentNotification: Notification? = nil

    var contacts: some View {
        Group {
            // TODO: Figure out how to layout this correctly.
            Section(header: Text(data.shouldSeeDoctor ? "Your tests' performances suggest that you should visit your doctor" : "Stay Connected")) {
            }
            GeometryReader { geometry in
                DetailedContactView(contactID: OCKContact.ID.KathleenPoston.rawValue)
                    .frame(width: geometry.size.width)
            }
            .frame(height: 230)
        }
    }

    var currentTests: some View {
        Section(header: Text("Available Tests")) {
            ForEach(data.currNotifications) { notification in
                InstructionsTaskView(
                    title: Text(notification.testName),
                    detail: Text(notification.text),
                    instructions: nil,
                    isComplete: data.done.contains(notification.id),
                    action: {
                        currentNotification = notification
                        showingTestDetail = true
                    }
                )
            }
        }
    }

    var futureTests: some View {
        Section(header: Text("Upcoming Tests and Cautions")) {
            ForEach(self.data.upcomingNotifications) { notification in
                SimpleTaskView(
                    title: Text(notification.testName),
                    detail: Text(notification.text)
                ) {
                    notification.studyItem.image
                        .resizable()
                        .imageScale(.large)
                        .frame(width: 32, height: 32, alignment: .center)
                        .padding()
                        .foregroundColor(.accentColor)
                }
            }
        }
    }

    var tests: some View {
        Group {
            currentTests
            Spacer()
                .padding(.bottom)
            futureTests
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)

                PlainList {
                    if #available(iOS 14, *) {
                        // Optional state doesn't update unless displayed.
                        // https://developer.apple.com/forums/thread/652080
                        Text(currentNotification?.testName ?? "")
                            .frame(maxHeight: 0)
                            // hidden is required, otherwise takes screen space
                            .hidden()
                    }
                    // Seems to be working in iOS 13,
                    // so don't do hidden if that crashes the app :(
                    // https://stackoverflow.com/questions/60920651

                    if data.shouldSeeDoctor {
                        contacts
                        Spacer()
                            .padding(.bottom)
                        tests
                    } else {
                        tests
                        Spacer()
                            .padding(.bottom)
                        contacts
                    }
                }
                .navigationBarItems(trailing: CurrentDate())
                .navigationBarTitle("Home")
            }
        }
        .sheet(isPresented: $showingTestDetail) {
            let notification = currentNotification!
            let study = notification.studyItem
            TaskVC(tasks: study.task) { result in
                switch result {
                case .success:
                    data.done.insert(notification.id)
                case .failure:
                    break // nothing to do
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct WelcomeNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeNotificationView()
            .accentColor(Color(UIColor(netHex: 0x41803d)))
            .environmentObject(NotificationsAndResults.shared)
    }
}
