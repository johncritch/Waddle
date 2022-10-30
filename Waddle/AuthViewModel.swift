//
//  AuthViewModel.swift
//  Waddle
//
//  Created by John Critchlow on 10/28/22.
//

import SwiftUI
import Firebase

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var didAuthenticateUser = false
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        print("DEBUG: User session is \(String(describing: self.userSession?.uid))")
    }
    
    func login(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email.lowercased(), password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to sign in with error '\(error.localizedDescription)'")
                return
            }
            
            guard let user = result?.user else { return }
            self.userSession = user
            
            print("DEBUG: Did log user in.")
        }
    }
    
    func register(withEmail email: String, password: String, first: String, last: String, username: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to register with error '\(error.localizedDescription)'")
                return
            }
            
            guard let user = result?.user else { return }
            
            print("DEBUG: Registered user successfully")
            print("DEBUG: User is \(String(describing: self.userSession?.uid))")
            
            let data = ["email": email.lowercased(),
                        "username": username.lowercased(),
                        "first": first,
                        "last": last,
                        "uid": user.uid]
            
            Firestore.firestore().collection("users")
                .document(user.uid)
                .setData(data) { _ in
                    self.didAuthenticateUser = true
                }

        }
    }
    
    func signOut() {
        // sets user to nill so app shows login
        userSession = nil
        
        // signs user out on server
        try? Auth.auth().signOut()
    }
}
