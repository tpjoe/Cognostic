//
//  CareKitChartViews.swift
//  Cognostic
//
//  Created by Vicky Xiang on 4/7/21.
//  Copyright © 2020-2021 Cognostic. All rights reserved.
//

import SwiftUI
import CareKit
import CareKitUI
import CareKitStore
import UIKit

struct CareKitChartViews: UIViewRepresentable {
    @EnvironmentObject var config: CKPropertyReader

    func makeUIView(context: Context) -> UIView {
        let chartView = OCKCartesianChartView(type: .line)

        chartView.tintColor = config.readColor(query: "Primary Color")

        chartView.headerView.detailLabel.text = "Your Score Overview"

        let mainString = "Status: Good"
        let range = (mainString as NSString).range(of: "Good")

        let mutableAttributedString = NSMutableAttributedString(string: mainString)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                             value: UIColor.systemGreen,
                                             range: range)

        chartView.headerView.titleLabel.attributedText = mutableAttributedString

        chartView.graphView.dataSeries = [
            OCKDataSeries(values: [9, 10, 9, 8, 10, 7],
                          title: "Aggregated Score Index")
        ]
        chartView.graphView.yMinimum = -1
        chartView.graphView.yMaximum = 11
        chartView.graphView.horizontalAxisMarkers = [
            "1/20", "4/20", "7/20", "10/20", "1/21", "4/21"
        ]
        return chartView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // do nothing
    }
}

/*
struct CareKitChartViews: UIViewControllerRepresentable {
    let weekOfDate: Date
    //let configurations: [OCKDataSeriesConfiguration]
    func makeUIViewController(context: Context) -> UIViewController {
        return OCKChartViewController(
            viewSynchronizer: OCKCartesianChartViewSynchronizer(plotType: .line, selectedDate: Date()),
            weekOfDate: weekOfDate,
            configurations: [
                OCKDataSeriesConfiguration(
                    taskID: "exampleScore",
                    legendTitle: "Score Overview",
                    gradientStartColor: .lightGray,
                    gradientEndColor: .green,
                    markerSize: 10,
                    eventAggregator: OCKEventAggregator.custom { _ in
                        Double.random(in: 0..<4)
                    }
                ),
            ],
            storeManager: CKCareKitManager.shared.synchronizedStoreManager
        )
    }
    

    func updateUIViewController(_ uiViewController: UIViewController,
                                context: Context) {
        // nothing to do
    }
}


*/
