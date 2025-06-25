import 'dart:math';

class Path {
  List<List<int>> path;
  int fitness;

  Path(this.path, this.fitness);
}

class GeneticPathfinding {
  final int populationSize;
  final int gridSize;
  final List<List<int>> grid;
  final Random random = Random();

  GeneticPathfinding(this.populationSize, this.gridSize, this.grid);

  List<Path> initializePopulation() {
    return List.generate(populationSize, (_) {
      final path = _generateRandomPath();
      final fitness = _calculateFitness(path);
      return Path(path, fitness as int);
    });
  }

  List<List<int>> _generateRandomPath() {
    final path = <List<int>>[];
    int x = 0;
    int y = 0;
    path.add([x, y]);

    while (x != gridSize - 1 || y != gridSize - 1) {
      final directions = [
        [0, 1],  // Right
        [1, 0],  // Down
        [0, -1], // Left
        [-1, 0], // Up
      ];

      final direction = directions[random.nextInt(directions.length)];
      final newX = x + direction[0];
      final newY = y + direction[1];

      if (newX >= 0 && newX < gridSize && newY >= 0 && newY < gridSize && grid[newY][newX] == 0) {
        x = newX;
        y = newY;
        path.add([x, y]);
      }
    }

    return path;
  }

  double _calculateFitness(List<List<int>> path) {
    // Fitness is the inverse of the path length
    return 1 / path.length;
  }

  List<Path> _selectParents(List<Path> population) {
    // Tournament selection
    final tournamentSize = 5;
    final parents = <Path>[];

    for (int i = 0; i < populationSize; i++) {
      final tournament = List.generate(tournamentSize, (_) => population[random.nextInt(populationSize)]);
      tournament.sort((a, b) => b.fitness.compareTo(a.fitness));
      parents.add(tournament.first);
    }

    return parents;
  }

  List<List<int>> _crossover(List<List<int>> parent1, List<List<int>> parent2) {
    final child = <List<int>>[];
    final minLength = min(parent1.length, parent2.length);
    final crossoverPoint = random.nextInt(minLength);

    for (int i = 0; i < crossoverPoint; i++) {
      child.add(parent1[i]);
    }

    for (int i = crossoverPoint; i < parent2.length; i++) {
      child.add(parent2[i]);
    }

    return child;
  }

  void _mutate(List<List<int>> path) {
    for (int i = 0; i < path.length; i++) {
      if (random.nextDouble() < 0.1) { // Mutation rate of 0.1
        final directions = [
          [0, 1],  // Right
          [1, 0],  // Down
          [0, -1], // Left
          [-1, 0], // Up
        ];

        final direction = directions[random.nextInt(directions.length)];
        final newX = path[i][0] + direction[0];
        final newY = path[i][1] + direction[1];

        if (newX >= 0 && newX < gridSize && newY >= 0 && newY < gridSize && grid[newY][newX] == 0) {
          path[i] = [newX, newY];
        }
      }
    }
  }

  List<Path> _createNewGeneration(List<Path> parents) {
    final newGeneration = <Path>[];

    for (int i = 0; i < populationSize; i += 2) {
      final parent1 = parents[i];
      final parent2 = parents[i + 1];

      final child1 = _crossover(parent1.path, parent2.path);
      final child2 = _crossover(parent2.path, parent1.path);

      _mutate(child1);
      _mutate(child2);

      newGeneration.add(Path(child1, _calculateFitness(child1) as int));
      newGeneration.add(Path(child2, _calculateFitness(child2) as int));
    }

    return newGeneration;
  }

  void run(int generations) {
    var population = initializePopulation();

    for (int generation = 0; generation < generations; generation++) {
      final parents = _selectParents(population);
      population = _createNewGeneration(parents);

      final bestPath = population.reduce((a, b) => a.fitness > b.fitness ? a : b);
      print("Generation ${generation + 1}: Best Fitness = ${bestPath.fitness}, Path Length = ${bestPath.path.length}");
    }

    final bestPath = population.reduce((a, b) => a.fitness > b.fitness ? a : b);
    print("Best Path: $bestPath");
  }
}

void main() {
  final grid = [
    [0, 0, 0, 0, 0],
    [0, 1, 1, 0, 0],
    [0, 0, 0, 0, 1],
    [0, 0, 1, 1, 0],
    [0, 0, 0, 0, 0],
  ];

  final ga = GeneticPathfinding(50, 5, grid);
  ga.run(100);
}
