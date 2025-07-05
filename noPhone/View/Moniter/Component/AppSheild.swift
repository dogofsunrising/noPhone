import SwiftUI
import ManagedSettings
import DeviceActivity
import FamilyControls

public struct AppShieldView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var selection : FamilyActivitySelection
    @State private var isPresented: Bool = false
    @StateObject var store = ManagedSettingsStore()

    public var body: some View {
        ZStack{
            Color(ButtonColor(how: .undefault, scheme: colorScheme))
                .ignoresSafeArea()
            VStack {
                Text("アプリ使用制限")
                                .font(.title2)
                                .bold()
                            
                            Button {
                                isPresented = true
                            } label: {
                                Text("制限するアプリを選択")
                                    .frame(maxWidth: .infinity)
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                            .familyActivityPicker(isPresented: $isPresented, selection: $selection)
                            .onChange(of: selection) {
                                // 任意のログや処理
                            }

                            Button {
                                let applications = selection.applicationTokens
                                store.shield.applications = applications.isEmpty ? nil : applications
                                
                                let categories = selection.categoryTokens
                                store.shield.applicationCategories = applications.isEmpty ? nil : .specific(categories)
                                
                                let webDomains = selection.webDomainTokens
                                store.shield.webDomains = applications.isEmpty ? nil : webDomains
                                store.shield.webDomainCategories = applications.isEmpty ? nil : .specific(categories)
                            } label: {
                                Text("選択したアプリの制限を開始")
                                    .frame(maxWidth: .infinity)
                            }
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .foregroundColor(.red)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.red, lineWidth: 1)
                            )

                            Button {
                                store.clearAllSettings()
                            } label: {
                                Text("全てのアプリの制限を解除")
                                    .frame(maxWidth: .infinity)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .foregroundColor(.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.systemBackground))
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        )
                        .padding()
            }
        .onAppear() {
//            Task {
//                await authorize()
//            }
        }
    }
}
