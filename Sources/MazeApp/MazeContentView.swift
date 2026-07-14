import SwiftUI

struct MazeContentView: View {
  @Bindable var model: MazeViewModel

  var body: some View {
    MazeCanvas(maze: model.maze, solution: model.showsSolution ? model.solution : [])
      .frame(minWidth: 520, minHeight: 520)
      .padding()
      .toolbar {
        ToolbarItemGroup {
          Button("New Maze", systemImage: "arrow.clockwise") { model.newMaze() }
          Toggle("Solution", isOn: $model.showsSolution)
          Slider(
            value: Binding(
              get: { Double(model.mazeSize) },
              set: {
                model.mazeSize = Int($0)
                model.newMaze()
              }
            ),
            in: 12...40,
            step: 1
          )
          .frame(width: 120)
          .accessibilityLabel("Maze size")
        }
      }
  }
}
