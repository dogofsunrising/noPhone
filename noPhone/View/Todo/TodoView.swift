import SwiftUI

struct TodoView: View {
    @State private var todos: [TodoItem] = []
    @State private var newTodo: String = ""
    @FocusState private var isInputActive: Bool

    var body: some View {
        ZStack {
            // 背景タップでフォーカスを外す（＝キーボードを閉じる）
            Color(.systemBackground)
                .ignoresSafeArea()
                .onTapGesture {
                    isInputActive = false
                }
            VStack {
                HStack{
                    Spacer()
                    // 編集ボタン（移動や削除を有効にする）
                    EditButton()
                }
                .padding(.horizontal)
                
                HStack {
                    TextField("新しいToDoを入力", text: $newTodo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading)
                        .focused($isInputActive)
                    
                    Button(action: {
                        guard !newTodo.isEmpty else { return }
                        addTodo(todo: TodoItem(text: newTodo))
                        newTodo = ""
                        isInputActive = false
                    }) {
                        Text("追加")
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
                
                
                List {
                    // ForEach部分
                    ForEach(Array(todos.enumerated()), id: \.element.id) { index, item in
                        HStack {
                            Text("\(index + 1).")
                            Text(item.text)
                            Spacer()
                        }
                    }
                    .onDelete(perform: removeTodos)
                    .onMove(perform: moveTodos)
                }
            }
        }
        .onAppear {
            loadTodo()
        }
    }

    private func addTodo(todo: TodoItem) {
        todos.append(todo)
        saveTodo()
    }

    private func removeTodos(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
        saveTodo()
    }

    private func moveTodos(from source: IndexSet, to destination: Int) {
        todos.move(fromOffsets: source, toOffset: destination)
        saveTodo()
    }

    private func moveUp(index: Int) {
        guard index > 0 else { return }
        todos.swapAt(index, index - 1)
        saveTodo()
    }

    private func moveDown(index: Int) {
        guard index < todos.count - 1 else { return }
        todos.swapAt(index, index + 1)
        saveTodo()
    }

    private func saveTodo() {
        if let data = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(data, forKey: "todoList")
        }
    }

    private func loadTodo() {
        if let data = UserDefaults.standard.data(forKey: "todoList"),
           let decoded = try? JSONDecoder().decode([TodoItem].self, from: data) {
            todos = decoded
        }
    }
}

struct TodoItem: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    var text: String
}
