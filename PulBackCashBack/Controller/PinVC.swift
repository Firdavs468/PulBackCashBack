//
//  PinVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 01/11/21.
//

import UIKit
import LocalAuthentication

class PinVC: UIViewController {
    
    
    @IBOutlet var numbersButton: [UIButton]!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ПИН-код"
        navigationController?.navigationBar.barTintColor = UIColor.green
        cornerView()
        startAuthentication()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        let vc = TabBarController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func startAuthentication() {
        let contet = LAContext()
        let reason = "Biometric Authntication testing !! "
        var authError: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if contet.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                contet.localizedCancelTitle = "Cancel"
                contet.localizedFallbackTitle = ""
                contet.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, evaluateError in
                    DispatchQueue.main.async {
                        if success {
                            let alert = UIAlertController(title: "Success", message: "Successfully Authenticated", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            // User did not authenticate successfully, look at error and take appropriate action
                            print(evaluateError?.localizedDescription)
                        }
                    }
                }
            } else {
                // Could not evaluate policy; look at authError and present an appropriate message to user
                print("Sorry!!.. Could not evaluate policy.\(authError?.localizedDescription ?? "")")
            }
        } else {
            print("This feature is not supported.")
        }
    }
    
    func cornerView() {
        nextButton.layer.cornerRadius = nextButton.frame.height/2
        for number in numbersButton {
            number.layer.cornerRadius = number.frame.height/6
        }
    }
    
}
