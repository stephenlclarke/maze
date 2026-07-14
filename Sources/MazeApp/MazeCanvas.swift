import MazeCore
import SwiftUI

struct MazeCanvas: View {
  let maze: Maze
  let solution: [Coordinate]

  var body: some View {
    Canvas { context, size in
      let cell = min(size.width / CGFloat(maze.columns), size.height / CGFloat(maze.rows))
      let origin = CGPoint(
        x: (size.width - cell * CGFloat(maze.columns)) / 2,
        y: (size.height - cell * CGFloat(maze.rows)) / 2
      )

      drawSolution(in: &context, cell: cell, origin: origin)
      drawWalls(in: &context, cell: cell, origin: origin)
      drawEndpoints(in: &context, cell: cell, origin: origin)
    }
    .accessibilityLabel("Generated maze")
  }

  private func drawSolution(in context: inout GraphicsContext, cell: CGFloat, origin: CGPoint) {
    guard solution.count > 1 else { return }

    var route = Path()
    for (offset, point) in solution.enumerated() {
      let location = CGPoint(
        x: origin.x + (CGFloat(point.column) + 0.5) * cell,
        y: origin.y + (CGFloat(point.row) + 0.5) * cell
      )
      if offset == 0 {
        route.move(to: location)
      } else {
        route.addLine(to: location)
      }
    }
    context.stroke(route, with: .color(.accentColor), lineWidth: max(2, cell * 0.18))
  }

  private func drawWalls(in context: inout GraphicsContext, cell: CGFloat, origin: CGPoint) {
    for row in 0..<maze.rows {
      for column in 0..<maze.columns {
        let point = Coordinate(column: column, row: row)
        let x = origin.x + CGFloat(column) * cell
        let y = origin.y + CGFloat(row) * cell
        var walls = Path()
        if maze.hasWall(at: point, toward: .north) {
          addHorizontalWall(to: &walls, x: x, y: y, length: cell)
        }
        if maze.hasWall(at: point, toward: .west) {
          addVerticalWall(to: &walls, x: x, y: y, length: cell)
        }
        if row == maze.rows - 1 { addHorizontalWall(to: &walls, x: x, y: y + cell, length: cell) }
        if column == maze.columns - 1 {
          addVerticalWall(to: &walls, x: x + cell, y: y, length: cell)
        }
        context.stroke(walls, with: .foreground, lineWidth: max(1, cell * 0.07))
      }
    }
  }

  private func drawEndpoints(in context: inout GraphicsContext, cell: CGFloat, origin: CGPoint) {
    let start = CGRect(
      x: origin.x + cell * 0.25, y: origin.y + cell * 0.25, width: cell * 0.5, height: cell * 0.5)
    let goal = CGRect(
      x: origin.x + (CGFloat(maze.goal.column) + 0.25) * cell,
      y: origin.y + (CGFloat(maze.goal.row) + 0.25) * cell,
      width: cell * 0.5,
      height: cell * 0.5
    )
    context.fill(Path(ellipseIn: start), with: .color(.green))
    context.fill(Path(ellipseIn: goal), with: .color(.red))
  }

  private func addHorizontalWall(to path: inout Path, x: CGFloat, y: CGFloat, length: CGFloat) {
    path.move(to: CGPoint(x: x, y: y))
    path.addLine(to: CGPoint(x: x + length, y: y))
  }

  private func addVerticalWall(to path: inout Path, x: CGFloat, y: CGFloat, length: CGFloat) {
    path.move(to: CGPoint(x: x, y: y))
    path.addLine(to: CGPoint(x: x, y: y + length))
  }
}
