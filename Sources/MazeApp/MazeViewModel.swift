import MazeCore
import Observation

@Observable
final class MazeViewModel {
  var maze = MazeGenerator.generate(columns: 24, rows: 24)
  var showsSolution = false
  var mazeSize = 24

  var solution: [Coordinate] { maze.solution() }

  func newMaze() {
    maze = MazeGenerator.generate(columns: mazeSize, rows: mazeSize)
  }
}
