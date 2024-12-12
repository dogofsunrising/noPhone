import SwiftUI

struct AddTimerView: View {
    @Binding var isPresented: Bool
    @Binding var timerList: [Int]

    @State private var hour: Int = 0
    @State private var minute: Int = 0
    @State private var second: Int = 0

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    // 時間Picker
                    Picker(selection: $hour, label: Text("Hours")) {
                        ForEach(0..<100, id: \.self) { index in
                            Text("\(index)").tag(index)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    Text("h")

                    // 分Picker
                    Picker(selection: $minute, label: Text("Minutes")) {
                        ForEach(0..<60, id: \.self) { index in
                            Text(String(format: "%02d", index)).tag(index)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    Text("m")

                    // 秒Picker
                    Picker(selection: $second, label: Text("Seconds")) {
                        ForEach(0..<60, id: \.self) { index in
                            Text(String(format: "%02d", index)).tag(index)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    Text("s")
                }
                .padding()

                Button {
                    saveTimer()
                } label: {
                    Text("保存")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .navigationBarTitle("タイマー追加", displayMode: .inline)
            .navigationBarItems(
                leading: Button("キャンセル") {
                    isPresented = false
                }
            )
            .onAppear {
                hour = 0
                minute = 0
                second = 0
            }
        }
    }

    // タイマーを保存する関数
    private func saveTimer() {
        let totalSeconds = hour * 3600 + minute * 60 + second
        if totalSeconds > 0 {
            timerList.append(totalSeconds)
            timerList.sort()
        }
        isPresented = false
    }
}

