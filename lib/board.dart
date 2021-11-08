import 'dart:math';

class Tile {
  int x = 0;
  int y = 0;
  int value = 0;

  Tile({required this.x, required this.y, required this.value});
}

class GameBoard {
  int size = 0;
  int startingTiles = 2;
  List<List<int>> tiles = [
    [0]
  ];

  GameBoard({required this.size}) {
    reset();
  }

  void reset() {
    tiles = List.generate(size, (i) => List.generate(size, (_) => 0),
        growable: false);

    for (int i = 0; i < startingTiles; i++) {
      addRandomTile();
    }
  }

  void eachTile(Function callback) {
    for (int x = 0; x < size; x++) {
      for (int y = 0; y < size; y++) {
        callback(Tile(x: x, y: y, value: tiles[x][y]));
      }
    }
  }

  List get availableTiles {
    List availableTiles = [];

    eachTile((Tile tile) {
      if (tile.value == 0) {
        availableTiles.add(tile);
      }
    });

    return availableTiles;
  }

  Tile get randomAvailableTile {
    return availableTiles[Random().nextInt(availableTiles.length)];
  }

  void insertTile(Tile tile) {
    tiles[tile.x][tile.y] = tile.value;
  }

  void addRandomTile() {
    Tile newTile = randomAvailableTile;
    newTile.value = Random().nextDouble() < 0.9 ? 2 : 4;

    insertTile(newTile);
  }

  int get total {
    int total = 0;

    eachTile((Tile tile) {
      total = total + tile.value;
    });

    return total;
  }

  List<int> _moveLeft(List<int> col) {
    List<int> newCol = List.generate(size, (_i) => 0);
    int j = 0;
    int previous = -1;
    for (int i = 0; i < size; i++) {
      if (col[i] != 0) {
        if (previous == -1) {
          previous = col[i];
        } else {
          if (previous == col[i]) {
            newCol[j] = 2 * col[i];
            previous = -1;
          } else {
            newCol[j] = previous;
            previous = col[i];
          }
          j++;
        }
      }
      if (previous != -1) {
        newCol[j] = previous;
      }
    }
    return newCol;
  }

  List<List<int>> _rotate90(List<List<int>> array, int direction) {
    for (int r = 0; r < direction.abs(); r++) {
      array = _rotateMatrix(size, array);
    }

    return array;
  }

  List<List<int>> _rotateMatrix(int N, List<List<int>> mat) {
    for (int x = 0; x < N / 2; x++) {
      for (int y = x; y < N - x - 1; y++) {
        int temp = mat[x][y];

        mat[x][y] = mat[y][N - 1 - x]; // Move values from right to top
        mat[y][N - 1 - x] =
            mat[N - 1 - x][N - 1 - y]; // Move values from bottom to right
        mat[N - 1 - x][N - 1 - y] =
            mat[N - 1 - y][x]; // Move values from left to bottom

        mat[N - 1 - y][x] = temp;
      }
    }

    return mat;
  }

  void move(direction) {
    var directionMap = {'left': 0, 'up': 1, 'right': 2, 'down': 3};
    var directionInt = (directionMap[direction] ?? 0);
    print(direction);
    print(directionInt);
    printMatrix(tiles, 'original');
    var rotatedBoard = _rotate90(tiles, directionInt);
    List<List<int>> newBoard = List.generate(
        size, (i) => List.generate(size, (_) => 0),
        growable: false);

    for (int i = 0; i < size; i++) {
      newBoard[i] = _moveLeft(rotatedBoard[i]);
    }
    printMatrix(rotatedBoard, 'rotatedBoard');
    printMatrix(newBoard, 'newBoard');
    tiles = _rotate90(newBoard, 4 - directionInt);
    printMatrix(tiles, 'tiles');
  }
}

void printMatrix(List<List<int>> matrix, String title) {
  print('\n$title');
  for (int i = 0; i < matrix.length; i++) {
    print(matrix[i]);
  }
}
