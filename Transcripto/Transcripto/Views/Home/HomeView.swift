//
//  HomeView.swift
//  Transcripto
//
//  Created by Jaymeen Unadkat on 21/02/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    LiveAudioView()
                } label: {
                    Text("Live text recognition")
                }

                NavigationLink {
                    AudioToTextView()
                } label: {
                    Text("Text from audio")
                }

                NavigationLink {
                    VideoToTextView()
                } label: {
                    Text("Text from video")
                }

            }
        }
    }
}

#Preview {
    HomeView()
}
