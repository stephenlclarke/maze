import SwiftUI

@main
struct MazeApp: App {
  @State private var model = MazeViewModel()

  var body: some Scene {
    WindowGroup("Maze", id: "maze") {
      MazeContentView(model: model)
    }
    .commands {
      CommandMenu("Maze") {
        Button("New Maze") { model.newMaze() }
          .keyboardShortcut("n")
        Button(model.showsSolution ? "Hide Solution" : "Show Solution") {
          model.showsSolution.toggle()
        }
        .keyboardShortcut(.return, modifiers: .command)
      }
    }
  }
}
