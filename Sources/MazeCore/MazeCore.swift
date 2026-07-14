import Foundation

public struct Coordinate: Hashable, Sendable {
  public let column: Int
  public let row: Int

  public init(column: Int, row: Int) {
    self.column = column
    self.row = row
  }
}

public enum Direction: CaseIterable, Sendable {
  case north, east, south, west

  fileprivate var wall: UInt8 { 1 << index }
  fileprivate var index: UInt8 {
    switch self {
    case .north: 0
    case .east: 1
    case .south: 2
    case .west: 3
    }
  }

  fileprivate var opposite: Direction {
    switch self {
    case .north: .south
    case .east: .west
    case .south: .north
    case .west: .east
    }
  }

  fileprivate func moving(from coordinate: Coordinate) -> Coordinate {
    switch self {
    case .north: Coordinate(column: coordinate.column, row: coordinate.row - 1)
    case .east: Coordinate(column: coordinate.column + 1, row: coordinate.row)
    case .south: Coordinate(column: coordinate.column, row: coordinate.row + 1)
    case .west: Coordinate(column: coordinate.column - 1, row: coordinate.row)
    }
  }
}

public struct Maze: Sendable {
  public let columns: Int
  public let rows: Int
  private var walls: [UInt8]

  public init(columns: Int, rows: Int) {
    precondition(columns > 1 && rows > 1)
    self.columns = columns
    self.rows = rows
    walls = Array(repeating: 0b1111, count: columns * rows)
  }

  public var start: Coordinate { Coordinate(column: 0, row: 0) }
  public var goal: Coordinate { Coordinate(column: columns - 1, row: rows - 1) }

  public func contains(_ coordinate: Coordinate) -> Bool {
    coordinate.column >= 0 && coordinate.column < columns && coordinate.row >= 0
      && coordinate.row < rows
  }

  public func hasWall(at coordinate: Coordinate, toward direction: Direction) -> Bool {
    walls[index(of: coordinate)] & direction.wall != 0
  }

  public func reachableNeighbors(of coordinate: Coordinate) -> [Coordinate] {
    Direction.allCases.compactMap { direction in
      let neighbor = direction.moving(from: coordinate)
      return contains(neighbor) && !hasWall(at: coordinate, toward: direction) ? neighbor : nil
    }
  }

  fileprivate mutating func carve(from coordinate: Coordinate, toward direction: Direction) {
    let neighbor = direction.moving(from: coordinate)
    walls[index(of: coordinate)] &= ~direction.wall
    walls[index(of: neighbor)] &= ~direction.opposite.wall
  }

  private func index(of coordinate: Coordinate) -> Int {
    coordinate.row * columns + coordinate.column
  }
}

public enum MazeGenerator {
  public static func generate(columns: Int, rows: Int, seed: UInt64) -> Maze {
    var maze = Maze(columns: columns, rows: rows)
    var random = SplitMix64(seed: seed)
    var visited: Set<Coordinate> = [maze.start]
    var stack = [maze.start]

    while let current = stack.last {
      let candidates = Direction.allCases.filter {
        let next = $0.moving(from: current)
        return maze.contains(next) && !visited.contains(next)
      }
      guard !candidates.isEmpty else {
        _ = stack.popLast()
        continue
      }
      let direction = candidates[Int(random.next() % UInt64(candidates.count))]
      let next = direction.moving(from: current)
      maze.carve(from: current, toward: direction)
      visited.insert(next)
      stack.append(next)
    }
    return maze
  }

  public static func generate(columns: Int, rows: Int) -> Maze {
    generate(columns: columns, rows: rows, seed: UInt64.random(in: .min ... .max))
  }
}

extension Maze {
  public func solution() -> [Coordinate] {
    var queue = [start]
    var cursor = 0
    var previous: [Coordinate: Coordinate] = [:]
    var visited: Set<Coordinate> = [start]

    while cursor < queue.count {
      let current = queue[cursor]
      cursor += 1
      if current == goal { break }
      for next in reachableNeighbors(of: current) where visited.insert(next).inserted {
        previous[next] = current
        queue.append(next)
      }
    }

    var path = [goal]
    while let prior = previous[path.last!] { path.append(prior) }
    return path.reversed()
  }
}

private struct SplitMix64 {
  private var state: UInt64

  init(seed: UInt64) { state = seed }

  mutating func next() -> UInt64 {
    state &+= 0x9E37_79B9_7F4A_7C15
    var value = state
    value = (value ^ (value >> 30)) &* 0xBF58_476D_1CE4_E5B9
    value = (value ^ (value >> 27)) &* 0x94D0_49BB_1331_11EB
    return value ^ (value >> 31)
  }
}
