//
//  HomeView.swift
//  LexiScan
//
//  Created by Jaymeen Unadkat on 21/02/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            List {

                NavigationLink {
                    TextFromImageView()
                } label: {
                    Text("Text from image")
                }

                NavigationLink {
                    TextFromCameraView()
                } label: {
                    Text("Text from camera")
                }

            }
        }
    }
}

#Preview {
    HomeView()
}
