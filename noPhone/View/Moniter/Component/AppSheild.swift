import SwiftUI
import ManagedSettings
import DeviceActivity
import FamilyControls

public struct AppShieldView: View {
    @Binding var selection : FamilyActivitySelection
    @State private var isPresented: Bool = false
    @StateObject var store = ManagedSettingsStore()

    public var body: some View {
        ZStack{
            Color(.white)
                .ignoresSafeArea()
            VStack {
                Button {
                    isPresented = true
                } label: {
                    Text("制限するアプリを選択")
                }
                .familyActivityPicker(isPresented: $isPresented,
                                      selection: $selection)
                .onChange(of: selection) {
                    let applications = selection.applications
                    let categories = selection.categories
                    let webDomains = selection.webDomains
                }
                
                Button {
                    let applications = selection.applicationTokens
                    store.shield.applications = applications.isEmpty ? nil : applications
                    
                    // 選んだカテゴリを画面ロックする　from familycontroll
                    let categorys = selection.categoryTokens
                    store.shield.applicationCategories = applications.isEmpty ? nil : .specific(categorys)
                    
                    // 選んだWebカテゴリを画面ロックする　from familycontroll
                    let webcategorys = selection.categoryTokens
                    store.shield.webDomainCategories = applications.isEmpty ? nil : .specific(webcategorys)
                    
                    // 選んだwebドメインを画面ロックする　from familycontroll
                    let webDomains = selection.webDomainTokens
                    store.shield.webDomains = applications.isEmpty ? nil : webDomains
                } label: {
                    Text("選択したアプリの制限を開始")
                }
                
                Button {
                    store.clearAllSettings()
                } label: {
                    Text("全てのアプリの制限を解除")
                }
            }
        }.onAppear() {
//            Task {
//                await authorize()
//            }
        }
    }
}
