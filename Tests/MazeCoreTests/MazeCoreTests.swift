import Testing

@testable import MazeCore

@Test func generatedMazeConnectsStartToGoal() {
  let maze = MazeGenerator.generate(columns: 18, rows: 12, seed: 42)
  let path = maze.solution()

  #expect(path.first == maze.start)
  #expect(path.last == maze.goal)
  #expect(path.count > 1)
}

@Test func generationIsDeterministicForASeed() {
  let first = MazeGenerator.generate(columns: 10, rows: 10, seed: 7)
  let second = MazeGenerator.generate(columns: 10, rows: 10, seed: 7)

  #expect(first.solution() == second.solution())
}

@Test func solutionUsesOnlyOpenPassages() {
  let maze = MazeGenerator.generate(columns: 14, rows: 14, seed: 99)

  for (current, next) in zip(maze.solution(), maze.solution().dropFirst()) {
    #expect(maze.reachableNeighbors(of: current).contains(next))
  }
}
