//
//  HomeView.swift
//  PDFly
//
//  Created by Jaymeen Unadkat on 21/02/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            List {
                
                NavigationLink {
                    PDFEditorView()
                } label: {
                    Text("Edit PDF")
                }

                NavigationLink {
                    ImageToPDFView()
                } label: {
                    Text("Create pdf using images")
                }

            }
        }
    }
}

#Preview {
    HomeView()
}
