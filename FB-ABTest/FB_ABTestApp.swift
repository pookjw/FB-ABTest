//
//  FB_ABTestApp.swift
//  FB-ABTest
//
//  Created by Jinwoo Kim on 11/26/20.
//

import SwiftUI
import Firebase

@main
struct FB_ABTestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    FirebaseApp.configure()
                    
                    Installations.installations().authTokenForcingRefresh(true, completion: { (token, error) in
                        if let error = error {
                            print("Error fetching token: \(error)")
                        }
                        guard let token = token else {
                            return
                        }
                        print("Installation auth token: \(token)")
                    })
                }
        }
    }
}
