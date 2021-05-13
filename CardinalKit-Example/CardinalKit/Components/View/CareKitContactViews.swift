//
//  CareKitContactViews.swift
//  Cognostic
//
//  Created by Apollo Zhu on 4/5/21.
//  Copyright © 2020-2021 Cognostic. All rights reserved.
//

import SwiftUI
import CareKit
import CareKitUI

struct SimpleContactView: UIViewControllerRepresentable {
    let contactID: String
    func makeUIViewController(context: Context) -> UIViewController {
        return OCKSimpleContactViewController(
            contactID: contactID,
            storeManager: CKCareKitManager.shared.synchronizedStoreManager
        )
    }

    func updateUIViewController(_ uiViewController: UIViewController,
                                context: Context) {
        // nothing to do
    }
}

struct DetailedContactView: UIViewControllerRepresentable {
    let contactID: String
    func makeUIViewController(context: Context) -> UIViewController {
        return OCKDetailedContactViewController(
            contactID: contactID,
            storeManager: CKCareKitManager.shared.synchronizedStoreManager
        )
    }

    func updateUIViewController(_ uiViewController: UIViewController,
                                context: Context) {
        // nothing to do
    }
}
