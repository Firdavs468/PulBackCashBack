//
//  PinVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 01/11/21.
//

import UIKit
import LocalAuthentication

class PinVC: UIViewController {
    
    
    @IBOutlet weak var nextButtonTop: NSLayoutConstraint!
    @IBOutlet weak var passwordStack: UIStackView!
    @IBOutlet var numbersButton: [UIButton]!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ПИН-код"
        navigationController?.navigationBar.barTintColor = UIColor.green
        cornerView()
        //        startAuthentication()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        let vc = TabBarController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    @IBAction func touchIdButtonPressed(_ sender: Any) {
    }
    
    
    func authenticateUserTouchID() {
        let context : LAContext = LAContext()
        // Declare a NSError variable.
        let myLocalizedReasonString = "Authentication is needed to access your Home ViewController."
        var authError: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: myLocalizedReasonString) { success, evaluateError in
                if success // IF TOUCH ID AUTHENTICATION IS SUCCESSFUL, NAVIGATE TO NEXT VIEW CONTROLLER
                {
                    DispatchQueue.main.async{
                        print("Authentication success by the system")
                        //                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        //                        let homeVC = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        //                        self.navigationController?.pushViewController(homeVC, animated: true)
                        let home = HomeVC(nibName: "HomeVC", bundle: nil)
                        self.navigationController?.pushViewController(home, animated: true)
                    }
                }
                else // IF TOUCH ID AUTHENTICATION IS FAILED, PRINT ERROR MSG
                {
                    //                    if let error = error {
                    //                        let message = self.showErrorMessageForLAErrorCode(error.code)
                    //                        print(message)
                    //                    }
                }
            }
        }
    }
    
    //    //touch id or face id
    //    func startAuthentication() {
    //        let contet = LAContext()
    //        let reason = "Biometric Authntication testing !! "
    //        var authError: NSError?
    //        if #available(iOS 8.0, macOS 10.12.1, *) {
    //            if contet.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
    //                contet.localizedCancelTitle = "Cancel"
    //                contet.localizedFallbackTitle = ""
    //                contet.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, evaluateError in
    //                    DispatchQueue.main.async {
    //                        if success {
    //                            let alert = UIAlertController(title: "Success", message: "Successfully Authenticated", preferredStyle: .alert)
    //                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    //                            self.present(alert, animated: true, completion: nil)
    //                        } else {
    //                            // User did not authenticate successfully, look at error and take appropriate action
    //                            print(evaluateError?.localizedDescription ?? "")
    //                        }
    //                    }
    //                }
    //            } else {
    //                // Could not evaluate policy; look at authError and present an appropriate message to user
    //                print("Sorry!!.. Could not evaluate policy.\(authError?.localizedDescription ?? "")")
    //            }
    //        } else {
    //            print("This feature is not supported.")
    //        }
    //    }
    
    
    //cornerView
    func cornerView() {
        nextButton.layer.cornerRadius = nextButton.frame.height/2
        for number in numbersButton {
            number.layer.cornerRadius = number.frame.height/10
//            number.layer.shadowColor = UIColor.systemGray.cgColor
//            number.layer.shadowOffset = CGSize(width: 0, height: 0)
//            number.layer.shadowRadius = 5
//            number.layer.shadowOpacity = 0.2
        }
        
        //setup constraint
        if isSmalScreen568 {
            passwordStack.spacing = 25
            nextButtonTop.constant = 30
        }else {
            passwordStack.spacing = 35
            nextButtonTop.constant = 50
        }
    }
    
}





class BiometricIDAuth {
    private let context = LAContext()
    private let policy: LAPolicy
    private let localizedReason: String
    
    private var error: NSError?
    
    init(policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics,
         localizedReason: String = "Verify your Identity",
         localizedFallbackTitle: String = "Enter App Password",
         localizedCancelTitle: String = "Touch me not") {
        self.policy = policy
        self.localizedReason = localizedReason
        context.localizedFallbackTitle = localizedFallbackTitle
        context.localizedCancelTitle = localizedCancelTitle
    }
    
    private func biometricType(for type: LABiometryType) -> BiometricType {
        switch type {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            @unknown default:
                return .unknown
        }
    }
    
    private func biometricError(from nsError: NSError) -> BiometricError {
        let error: BiometricError
        
        switch nsError {
            case LAError.authenticationFailed:
                error = .authenticationFailed
            case LAError.userCancel:
                error = .userCancel
            case LAError.userFallback:
                error = .userFallback
            case LAError.biometryNotAvailable:
                error = .biometryNotAvailable
            case LAError.biometryNotEnrolled:
                error = .biometryNotEnrolled
            case LAError.biometryLockout:
                error = .biometryLockout
            default:
                error = .unknown
        }
        
        return error
    }
    
    func canEvaluate(completion: (Bool, BiometricType, BiometricError?) -> Void) {
        // Asks Context if it can evaluate a Policy
        // Passes an Error pointer to get error code in case of failure
        guard context.canEvaluatePolicy(policy, error: &error) else {
            // Extracts the LABiometryType from Context
            // Maps it to our BiometryType
            let type = biometricType(for: context.biometryType)
            
            // Unwraps Error
            // If not available, sends false for Success & nil in BiometricError
            guard let error = error else {
                return completion(false, type, nil)
            }
            
            // Maps error to our BiometricError
            return completion(false, type, biometricError(from: error))
        }
        
        // Context can evaluate the Policy
        completion(true, biometricType(for: context.biometryType), nil)
    }
    
    
    func evaluate(completion: @escaping (Bool, BiometricError?) -> Void) {
        // Asks Context to evaluate a Policy with a LocalizedReason
        context.evaluatePolicy(policy, localizedReason: localizedReason) { [weak self] success, error in
            // Moves to the main thread because completion triggers UI changes
            DispatchQueue.main.async {
                if success {
                    // Context successfully evaluated the Policy
                    completion(true, nil)
                } else {
                    // Unwraps Error
                    // If not available, sends false for Success & nil for BiometricError
                    guard let error = error else { return completion(false, nil) }
                    
                    // Maps error to our BiometricError
                    completion(false, self?.biometricError(from: error as NSError))
                }
            }
        }
    }
}

enum BiometricType {
    case none
    case touchID
    case faceID
    case unknown
}

enum BiometricError: LocalizedError {
    case authenticationFailed
    case userCancel
    case userFallback
    case biometryNotAvailable
    case biometryNotEnrolled
    case biometryLockout
    case unknown
    
    var errorDescription: String? {
        switch self {
            case .authenticationFailed: return "There was a problem verifying your identity."
            case .userCancel: return "You pressed cancel."
            case .userFallback: return "You pressed password."
            case .biometryNotAvailable: return "Face ID/Touch ID is not available."
            case .biometryNotEnrolled: return "Face ID/Touch ID is not set up."
            case .biometryLockout: return "Face ID/Touch ID is locked."
            case .unknown: return "Face ID/Touch ID may not be configured"
        }
    }
}
