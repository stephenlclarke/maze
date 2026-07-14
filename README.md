# Maze

<!-- markdownlint-disable MD013 -->
[![CI](https://github.com/stephenlclarke/maze/actions/workflows/ci.yml/badge.svg)](https://github.com/stephenlclarke/maze/actions/workflows/ci.yml)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=stephenlclarke_maze&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=stephenlclarke_maze)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=stephenlclarke_maze&metric=coverage)](https://sonarcloud.io/summary/new_code?id=stephenlclarke_maze)
<!-- markdownlint-enable MD013 -->

Maze is a native macOS SwiftUI rewrite of the original X11 maze visualizer. It
generates a perfect maze, animates its solution, and uses native toolbar, menu,
and keyboard controls.

## Requirements

- macOS 14 or later
- Swift 6.0 or later

## Build and run

```sh
swift build
swift test
./script/build_and_run.sh
```

The app supports `Command-N` for a fresh maze and `Command-Return` to show or
hide the solution.

## Quality workflow

```sh
make coverage-check
make sonar
```

`make coverage` writes `coverage.lcov` and converts it to SonarQube generic
`coverage.xml`; `make sonar` refuses to scan without that report. Import
SonarCloud project key `stephenlclarke_maze` for the quality and coverage badges
to populate.

## Legacy source

<!-- markdownlint-disable-next-line MD013 -->
The original C/X11 implementation lives in [`original/`](original) as historical reference and is not part of the Swift package.

## License

New Swift sources are MIT licensed. The retained historical source keeps its
original Sun Microsystems terms; see [LICENSE](LICENSE).
