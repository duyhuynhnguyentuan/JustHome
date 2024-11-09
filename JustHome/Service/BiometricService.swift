//
//  BiometricService.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 27/10/24.
//

import Foundation
import LocalAuthentication

class BiometricService {
    enum BiometricType {
        case none
        case face
        case touch
        case optic
    }
    
    func biometricType() -> BiometricType {
        let context = LAContext()
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touch
        case .faceID:
            return .face
        case .opticID:
            return .optic
        @unknown default:
            return .none
        }
    }
    
    func requestBiometricUnlock(completion: @escaping (Result<Bool, BiometricError>) -> Void) {
//        let credentials: Credentials? = Credentials(password: password)
        let context = LAContext()
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if let error = error {
            switch error.code {
            case -6:
                completion(.failure(.deniedAccess))
            case -7:
                if context.biometryType == .faceID {
                    completion(.failure(.noFaceIDEnrolled))
                } else if context.biometryType == .opticID {
                    completion(.failure(.noOpticIdEnrolled))
                } else {
                    completion(.failure(.noFingerprintEnrolled))
                }
            default:
                completion(.failure(.biometricError))
            }
            return
        }
        if canEvaluate {
            if context.biometryType != .none {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Need to access credentials.") { success, error in
                    DispatchQueue.main.async {
                        if error != nil {
                            completion(.failure(.biometricError))
                        } else {
                            completion(.success(true))
                        }
                    }
                }
            }
        }
    }
}
