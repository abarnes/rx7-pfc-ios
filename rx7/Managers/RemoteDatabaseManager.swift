//
//  RemoteDatabaseManager.swift
//  rx7
//
//  Created by Austin Barnes on 7/10/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation
import FirebaseFirestore
import ReactiveKit

class RemoteDatabaseManager {
    
    private(set) static var singleton = RemoteDatabaseManager()
    
    private let engineDataStateManager = EngineDataStateManager.singleton
    private(set) var drive: Drive? // this should move to EngineDataStateManager
    private let disposeBag = DisposeBag()
    
    private let db = Firestore.firestore()
    private var driveDatabaseRef: DocumentReference?
    
    private struct Constants {
        static let DrivesCollection = "drives"
        static let DriveDatapointsCollection = "datapoints"
    }
    
    init() {
        subscribeToDriveBeginning()
    }
    
    private func subscribeToDriveBeginning() {
        let didBeginDriveClosure: ((Bool) -> Void) = { [weak self] (didBegin) in
            guard didBegin, let `self` = self else { return }
            
            self.createDrive()
            self.subscribeToEngineData()
        }
        
        guard (!engineDataStateManager.didBeginDrive.value) else {
            didBeginDriveClosure(true)
            return
        }
        
        _ = engineDataStateManager.didBeginDrive.observeNext(with: didBeginDriveClosure).dispose(in: disposeBag)
    }
    
    private func subscribeToEngineData() {
        _ = engineDataStateManager.current.observeNext { [weak self] (engineDataPoint) in
            guard let engineDataPoint = engineDataPoint, let driveRef = self?.driveDatabaseRef else { return }
            driveRef.collection(Constants.DriveDatapointsCollection).addDocument(data: engineDataPoint.convertToFirestoreData())
        }.dispose(in: disposeBag)
    }
    
    private func createDrive() {
        let code = RandomStringGenerator.generate()
        drive = Drive(code: code, start: Date(), isLive: true)
        guard let drive = drive else { return }
        
        // create the drive in firestore
        driveDatabaseRef = db.collection(Constants.DrivesCollection).addDocument(data: drive.convertToFirestoreData()) { error in
            guard let error = error else { return }
            print("Error writing drive to Firebase: \(error)")
        }

    }
}
