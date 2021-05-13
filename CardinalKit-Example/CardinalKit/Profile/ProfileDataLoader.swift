//
//  ProfileDataLoader.swift
//  Cognostic
//
//  Created by Apollo Zhu on 4/5/21.
//  Copyright © 2020-2021 Cognostic. All rights reserved.
//

import ResearchKit
import FirebaseFirestore
import EFStorageKeychainAccess

func loadBasicInfo() {
    guard let authCollection = CKStudyUser.shared.authCollection else {
        print("not signed in")
        return
    }
    let db = Firestore.firestore()

    db.collection(authCollection + Constants.dataBucketSurveys)
        .whereField(FieldPath(["payload", "identifier"]), isEqualTo: "BasicInfo")
        .order(by: FieldPath(["payload", "endDate"]), descending: true)
        .limit(to: 1)
        .getDocuments { snapshot, error in
            guard let document = snapshot?.documents.first else {
                dump(error)
                return
            }
            guard let payload = document.data()["payload"],
                  let dict = payload as? [AnyHashable: Any],
                  let object = try? ORKESerializer.object(fromJSONObject: dict),
                  let result = object as? ORKTaskResult else {
                print("format error")
                return
            }
            updateBasicInfo(with: result)
            EFStorageKeychainAccessRef<ORKTaskResult>
                .forKey("BasicInfo").content = result
            print("update user info success")
        }
}

func updateBasicInfo(with taskResult: ORKTaskResult) {
    let studyUser: CKStudyUser = .shared

    if let nameResult = taskResult.stepResult(
        forStepIdentifier: ORKStep.Identifier
            .nameQuestionStep.rawValue)?
        .results?.first as? ORKTextQuestionResult,
       let name = nameResult.textAnswer {
        studyUser.name = name
    } else {
        studyUser.name = nil
    }

    if let dobResult = taskResult.stepResult(
        forStepIdentifier: ORKStep.Identifier
            .dobQuestionStep.rawValue)?
        .results?.first as? ORKDateQuestionResult,
       let date = dobResult.dateAnswer {
        studyUser.dateOfBirth = date
    } else {
        studyUser.dateOfBirth = nil
    }

    if let sexResult = taskResult.stepResult(
        forStepIdentifier: ORKStep.Identifier
            .sexQuestionStep.rawValue)?
        .results?.first as? ORKChoiceQuestionResult,
       let firstResult = sexResult.choiceAnswers?.first,
       let sexString = firstResult as? String {
        let sex: HKBiologicalSex
        switch sexString {
        case "HKBiologicalSexNotSet": sex = .notSet
        case "HKBiologicalSexFemale": sex = .female
        case "HKBiologicalSexMale": sex = .male
        case "HKBiologicalSexOther": sex = .other
        default: sex = .other
        }
        studyUser.sex = sex
    } else {
        studyUser.sex = .notSet
    }

    if let handednessResult = taskResult.stepResult(
        forStepIdentifier: ORKStep.Identifier
            .handedQuestionStep.rawValue)?
        .results?.first as? ORKChoiceQuestionResult,
       let firstAnswer = handednessResult.choiceAnswers?.first,
       let handedness = firstAnswer as? String {
        studyUser.handedness = handedness
    } else {
        studyUser.handedness = nil
    }

    if let locationResult = taskResult.stepResult(
        forStepIdentifier: ORKStep.Identifier
            .locationQuestionStep.rawValue)?
        .results?.first as? ORKLocationQuestionResult,
       let location = locationResult.locationAnswer,
       let zipCode = location.postalAddress?.postalCode {
        studyUser.zipCode = zipCode
    } else {
        studyUser.zipCode = nil
    }

    if let ethnicityResult = taskResult.stepResult(
        forStepIdentifier: ORKStep.Identifier
            .ethnicityQuestionStep.rawValue)?
        .results?.first as? ORKChoiceQuestionResult,
       let firstAnswer = ethnicityResult.choiceAnswers?.first,
       let ethnicity = firstAnswer as? String {
        studyUser.ethnicity = ethnicity
    } else {
        studyUser.ethnicity = nil
    }

    if let educationResult = taskResult.stepResult(
        forStepIdentifier: ORKStep.Identifier
            .educationQuestionStep.rawValue)?
        .results?.first as? ORKChoiceQuestionResult,
       let firstAnswer = educationResult.choiceAnswers?.first,
       let education = firstAnswer as? String {
        studyUser.education = education
    } else {
        studyUser.education = nil
    }
}
