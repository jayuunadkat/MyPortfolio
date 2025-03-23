//
//  DistrictListView.swift
//  OneRoasterUserData
//
//  Created by Jaymeen Unadkat on 24/02/25.
//

import SwiftUI

struct DistrictListView: View {
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            ForEach(0..<10, id: \.self) { i in
                DistrictCell()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    DistrictListView()
}
