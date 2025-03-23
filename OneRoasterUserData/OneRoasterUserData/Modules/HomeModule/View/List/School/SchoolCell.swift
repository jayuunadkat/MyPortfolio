struct SchoolCell: View {
    @State var isOpened: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            cellHeaderView
            if isOpened {
                schoolListView
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var cellHeaderView: some View {
        Button {
            withAnimation {
                isOpened.toggle()
            }
        } label: {
            HStack(spacing: 8) {
                Text("Hey Jaymeen!")
                    .font(.subheadline)
                    .bold()

                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .bold()
                    .rotationEffect(Angle(degrees: isOpened ? 90 : 0))
            }
        }
        .foregroundStyle(.black)
    }

    private var schoolListView: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(0..<10, id: \.self) { i in
                DistrictCell()
            }
        }
    }
}

#Preview {
    DistrictCell()
}
