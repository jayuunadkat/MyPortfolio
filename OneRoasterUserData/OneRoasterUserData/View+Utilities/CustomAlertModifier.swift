struct CustomAlertModifier: ViewModifier {
    @Binding var showAlert: Bool
    var alertData: AlertData
    var router: Router // Assuming you have a router object for navigation
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: $showAlert) {
                if alertData.isLogOut {
                    return Alert(
                        title: Text(alertData.title),
                        message: Text(alertData.message),
                        dismissButton: alertData.dismissButton
                    )
                } else {
                    return Alert(
                        title: Text(alertData.title),
                        message: Text(alertData.message),
                        dismissButton: alertData.dismissButton
                    )
                }
            }
    }
}

extension View {
    func customAlert(showAlert: Binding<Bool>, alertData: AlertData, router: Router) -> some View {
        self.modifier(CustomAlertModifier(showAlert: showAlert, alertData: alertData, router: router))
    }
}
