//
//  AcknowledgementsView.swift
//  Cognostic
//
//  Created by Apollo Zhu on 4/6/21.
//  Copyright © 2020-2021 Cognostic. All rights reserved.
//

import SwiftUI
import AcknowList

enum SwiftPMParser {
    struct Wrapper: Codable {
      struct Object: Codable {
        struct Pins: Codable {
          struct State: Codable {
            let branch: String?
            let revision: String
            let version: String?
          }

          let package: String
          let repositoryURL: URL
          let state: State
        }

        let pins: [Pins]
      }

      let object: Object
      let version: Int
    }

    static func parse(contentsOf url: URL) throws -> [Acknow] {
        let wrapper = try JSONDecoder()
            .decode(Wrapper.self, from: Data(contentsOf: url))
        return wrapper.object.pins.map { dependency in
            Acknow(title: dependency.package, text: """
            See \(dependency.repositoryURL) for license information.
            """)
        }
    }
}

struct AcknowVC: UIViewControllerRepresentable {
    let acknowledgement: Acknow

    func makeUIViewController(context: Context) -> some UIViewController {
        return AcknowViewController(acknowledgement: acknowledgement)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType,
                                context: Context) { }
}

struct AcknowledgementsView: View {
    @State
    var acknowledgements: [Acknow] = {
        let cocoapodsPath = Bundle.main
            .path(forResource: "Pods-Cognostic-acknowledgements", ofType: "plist")!
        let parser = AcknowParser(plistPath: cocoapodsPath)
        let swiftpmURL = Bundle.main.url(forResource: "Package",
                                        withExtension: "resolved")!
        let swiftPMDependencies = try! SwiftPMParser.parse(contentsOf: swiftpmURL)
        return parser.parseAcknowledgements() + swiftPMDependencies
    }()

    var list: some View {
        List {
            ForEach(acknowledgements, id: \.title) { acknowledgement in
                NavigationLink(
                    acknowledgement.title,
                    destination:
                        AcknowVC(acknowledgement: acknowledgement)
                        .navigationBarTitle(acknowledgement.title)
                )
            }
        }
    }

    var body: some View {
        if #available(iOS 14.0, *) {
            list
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Acknowledgments")
        } else {
            list
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Acknowledgments")
        }
    }
}

struct AcknowledgementsView_Previews: PreviewProvider {
    static var previews: some View {
        AcknowledgementsView()
    }
}
