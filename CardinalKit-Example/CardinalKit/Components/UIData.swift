//
//  UIData.swift
//  Cognostic
//
//  Created by Lucas Wang on 2020-09-12.
//  Copyright © 2020-2021 Cognostic. All rights reserved.
//

import Combine
import Foundation
import FirebaseFirestore

struct Notification: Identifiable {
    let id = UUID()
    let dateSent = Date()
    let testName: String
    let text: String
    let action: Bool
}

extension Notification {
    var studyItem: StudyItem {
        switch testName {
        case "User Survey": return StudyItem(study: .survey)
        case "Trailmaking A": return StudyItem(study: .trailMakingA)
        case "Trailmaking B": return StudyItem(study: .trailMakingB)
        case "Spatial Memory": return StudyItem(study: .spatial)
        case "Speech Recognition": return StudyItem(study: .speechRecognition)
        case "Amsler Grid": return StudyItem(study: .amslerGrid)
        case "Reaction Time": return StudyItem(study: .reaction)
        case "Tower of Hanoi": return StudyItem(study: .tower)
        case "PSAT": return StudyItem(study: .psat)
        case "Stroop Test": return StudyItem(study: .stroop)
        case "9-Hole Peg": return StudyItem(study: .nine)
        case "Tone Audiometry": return StudyItem(study: .tone)
        default:
            fatalError("Unrecognized test \(testName)")
        }
    }
}

struct Result: Identifiable {
    let id = UUID()
    let testName: String
    let scores: [Double]
}

class NotificationsAndResults: ObservableObject {
    @Published var currNotifications: [Notification]
    @Published var upcomingNotifications: [Notification]
    
    @Published var cogTests:[Notification]
    @Published var otherTests:[Notification]
    @Published var results: [Result] = []
    @Published var done = Set<UUID>()
    @Published var shouldSeeDoctor = false

    public static let shared = NotificationsAndResults()

    private init() {
        #warning("TODO: Integrate with CareKit scheduling")
        currNotifications = [
            Notification(testName: "User Survey", text: "Test is ready to be taken.", action: true),
            Notification(testName: "Trailmaking B", text: "Test is ready to be taken.", action: true)
        ]
        upcomingNotifications = [
            Notification(testName: "Trailmaking A", text: "Test can be taken starting tomorrow.", action: false),
            Notification(testName: "Spatial Memory", text: "Test is coming up in 3 days, please consume a moderate amount of caffeine only.", action: false),
            Notification(testName: "Amsler Grid", text: "Test is coming up next week, please be mindful of eyes usage.", action: false)
        ]
        
        cogTests = [
            Notification(testName: "User Survey", text: "Test is ready to be taken.", action: true),
            Notification(testName: "Trailmaking B", text: "Test is ready to be taken.", action: true),
            Notification(testName: "Spatial Memory", text: "Test will be ready on 04/09/21", action: false),
            Notification(testName: "Reaction Time", text: "Test will be ready on 05/01/21.", action: false),
            Notification(testName: "Tower of Hanoi", text: "Test will be ready on 05/03/21.", action: false),
            Notification(testName: "PSAT", text: "Test will be ready on 05/07/21.", action: false),
            Notification(testName: "Stroop Test", text: "Test will be ready on 06/01/21.", action: false)
        ]
        otherTests = [
            Notification(testName: "Amsler Grid", text: "Test will be ready tomorrow", action: false),
            Notification(testName: "9-Hole Peg", text: "Test will be ready on 05/01/21", action: false),
            Notification(testName: "Tone Audiometry", text: "Test will be ready on 05/01/21", action: false)
        ]
        guard let authCollection = CKStudyUser.shared.authCollection else {
            print("Not signed in")
            return
        }
        let db = Firestore.firestore()
        listener = db.collection(authCollection + "\(Constants.dataBucketSurveys)")
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    return
                }
                #warning("TODO: handle diff instead of entire collection")
                let studies: [Study] = snapshot.documents.compactMap { document in
                    let payload = document.data()["payload"] as! [String: Any]
                    switch payload["identifier"] as! String {
                    case "Trail making A":
                        return .trailA(
                            info: Info(payload),
                            numberOfErrors: (payload["results"] as! [Dict]).lazy
                                .filter { $0["identifier"] as! String == "trailmaking" }
                                .flatMap {
                                    ($0["results"] as! [Dict]).lazy
                                        .compactMap { $0["numberOfErrors"] as? Int }
                                }
                                .first!
                        )
                    case "Trail making B":
                        return .trailB(
                            info: Info(payload),
                            numberOfErrors: (payload["results"] as! [Dict]).lazy
                                .filter { $0["identifier"] as! String == "trailmaking" }
                                .flatMap {
                                    ($0["results"] as! [Dict]).lazy
                                        .compactMap { $0["numberOfErrors"] as? Int }
                                }
                                .first!
                        )
                    case "Speech Recognition":
                        return .speech(
                            info: Info(payload),
                            text: (payload["results"] as! [Dict]).lazy
                                .filter { $0["identifier"] as! String == "speech.recognition" }
                                .flatMap {
                                    ($0["results"] as! [Dict]).lazy
                                        .compactMap { $0["transcription"] as? Dict }
                                        .compactMap { $0["formattedString"] as? String }
                                }
                                .first!
                        )
                    case "Amsler Grid":
                        return .amsler(info: Info(payload))
                    case "Survey":
                        return .survey(info: Info(payload))
                    case "Reaction Time":
                        return .reaction(info: Info(payload))
                    case "Tower of Hanoi":
                        return .tower(info: Info(payload))
                    case "PSAT":
                        return .psat(info: Info(payload))
                    case "Stroop Test":
                        return .stroop(info: Info(payload))
                    case "Spatial Memory":
                        return .spatial(info: Info(payload))
                    case "9-Hole Peg":
                        return .nine(info: Info(payload))
                    case "Tone Audiometry":
                        return .tone(info: Info(payload))
                    case "BasicInfo":
                        return nil // nothing to report for this
                    default:
                        print(payload)
                        return nil
                    }
                }

                self.results = studies.lazy
                    .filter { $0.score != nil }
                    .grouped { $0.name }
                    .map { (key, value) in
                        Result(
                            testName: key,
                            scores: value
                                .sorted { $0.date < $1.date }
                                .map { floor($0.score! * 100) / 10 }
                        )
                    }
                    .sorted { $0.testName < $1.testName }
            }
    }
    
    func getLastestScore<T>(scores: [T]) -> T {
        // change based on the method used to sort the scores array by time (old->new OR new-> old)
        return scores.last!
    }

    enum Study {
        case survey(info: Info)
        case trailA(info: Info, numberOfErrors: Int)
        case trailB(info: Info, numberOfErrors: Int)
        case memory(info: Info)
        case speech(info: Info, text: String)
        case amsler(info: Info)
        case reaction(info: Info)
        case tower(info: Info)
        case psat(info: Info)
        case stroop(info: Info)
        case spatial(info: Info)
        case nine(info: Info)
        case tone(info: Info)

        var score: Double? {
            return error.map {
                return min(1, max(0, 1 - $0))
            }
        }

        private var error: Double? {
            switch self {
            case .survey:
                return nil
            case .trailA(_, numberOfErrors: let errors):
                return Double(errors) / 13
            case .trailB(_, numberOfErrors: let errors):
                return Double(errors) / 13
            case .memory:
                return -1
            case .speech(_, text: let text):
                let target = StudyTasks.speechRecognitionText
                return Double(text.levenshtein(from: target)) / Double(target.count)
            case .amsler:
                return -1
            case .reaction:
                return -1
            case .tower:
                return -1
            case .psat:
                return -1
            case .stroop:
                return -1
            case .spatial:
                return -1
            case .nine:
                return -1
            case .tone:
                return -1
            }
        }

        var date: Date {
            switch self {
            case .survey(info: let info):
                return info.endDate
            case .trailA(info: let info, _):
                return info.endDate
            case .trailB(info: let info, _):
                return info.endDate
            case .memory(info: let info):
                return info.endDate
            case .speech(info: let info, _):
                return info.endDate
            case .amsler(info: let info):
                return info.endDate
            case .reaction(info: let info):
                return info.endDate
            case .tower(info: let info):
                return info.endDate
            case .psat(info: let info):
                return info.endDate
            case .stroop(info: let info):
                return info.endDate
            case .spatial(info: let info):
                return info.endDate
            case .nine(info: let info):
                return info.endDate
            case .tone(info: let info):
                return info.endDate
            }
        }

        var name: String {
            switch self {
            case .survey:
                return "User Survey"
            case .trailA:
                return "Trailmaking A"
            case .trailB:
                return "Trailmaking B"
            case .memory:
                return "Spatial Memory"
            case .speech:
                return "Speech Recognition"
            case .amsler:
                return "Amsler Grid"
            case .reaction:
                return "Reaction Time"
            case .tower:
                return "Tower of Hanoi"
            case .psat:
                return "PSAT"
            case .stroop:
                return "Stroop Test"
            case .spatial:
                return "Spatial Memory"
            case .nine:
                return "9-Hole Peg"
            case .tone:
                return "Tone Audiometry"
            }
        }
    }

    typealias Dict = [String: Any]

    struct Info {
        let startDate: Date
        let endDate: Date

        static func date(from string: String) -> Date! {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
            return dateFormatter.date(from: string)
        }

        init(_ dict: Dict) {
            startDate = Info.date(from: dict["startDate"] as! String)
            endDate = Info.date(from: dict["endDate"] as! String)
        }
    }

    var listener: ListenerRegistration?
    deinit {
        listener?.remove()
    }
}

import CareKit
import CareKitStore
import Contacts

func populateCKCareKitManager(store: OCKStore) {
    createContacts(store: store)
}

extension OCKContact {
    enum ID: String {
        case KathleenPoston
    }
}

fileprivate func createContacts(store: OCKStore) {
    var name = PersonNameComponents()
    name.givenName = "Kathleen"
    name.familyName = "Poston"
    name.nameSuffix = "MD"
    var contact1 = OCKContact(id: OCKContact.ID.KathleenPoston.rawValue,
                              name: name, carePlanUUID: nil)
    // Turns out that this image is not used at all, well well well.
    // contact1.asset = "https://udallcenter.stanford.edu/wp-content/uploads/2016/10/Poston-Kathleen-MD.jpg"
    contact1.title = "Neurologist"
    contact1.role = "Dr. Poston evaluates your test results."
    // Communications should be done in some other ways
    // https://github.com/UWDevApp/TrialX/issues/23#issuecomment-814303494
    // contact1.emailAddresses = [OCKLabeledValue(label: CNLabelEmailiCloud, value: "udallcenter@stanford.edu")]
    // contact1.phoneNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(111) 111-1111")]
    // contact1.messagingNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(111) 111-1111")]
    contact1.organization = "Pacific Udall Center"

    contact1.address = {
        let address = OCKPostalAddress()
        address.street = "300 Pasteur Drive, Lane 235"
        address.city = "Stanford"
        address.state = "CA"
        address.postalCode = "94305"
        return address
    }()

    store.addContact(contact1)
    store.updateContact(contact1)
}
