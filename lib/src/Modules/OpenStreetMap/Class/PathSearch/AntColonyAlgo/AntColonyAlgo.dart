import 'dart:math';


class Ant {
  List<int> path;
  double pathLength;

  Ant(this.path, this.pathLength);
}

class AntColonyOptimization {
  final int numAnts;
  final int numCities;
  final List<List<double>> distances;
  final double evaporationRate;
  final double alpha;
  final double beta;
  final Random random = Random();

  List<List<double>> pheromones;

  AntColonyOptimization(this.numAnts, this.numCities, this.distances, this.evaporationRate, this.alpha, this.beta)
      : pheromones = List.generate(numCities, (_) => List.filled(numCities, 1.0));

  List<Ant> initializeAnts() {
    return List.generate(numAnts, (_) {
      final path = List.generate(numCities, (index) => index);
      path.shuffle(random);
      final pathLength = _calculatePathLength(path);
      return Ant(path, pathLength);
    });
  }

  double _calculatePathLength(List<int> path) {
    double length = 0.0;
    for (int i = 0; i < path.length - 1; i++) {
      length += distances[path[i]][path[i + 1]];
    }
    length += distances[path.last][path.first]; // Return to the start city
    return length;
  }

  void updatePheromones(List<Ant> ants) {
    // Evaporate pheromones
    for (int i = 0; i < numCities; i++) {
      for (int j = 0; j < numCities; j++) {
        pheromones[i][j] *= (1 - evaporationRate);
      }
    }

    // Deposit pheromones
    for (final ant in ants) {
      final contribution = 1.0 / ant.pathLength;
      for (int i = 0; i < ant.path.length - 1; i++) {
        final from = ant.path[i];
        final to = ant.path[i + 1];
        pheromones[from][to] += contribution;
        pheromones[to][from] += contribution; // Assuming symmetric distances
      }
      final from = ant.path.last;
      final to = ant.path.first;
      pheromones[from][to] += contribution;
      pheromones[to][from] += contribution; // Assuming symmetric distances
    }
  }

  List<int> constructPath() {
    final path = <int>[];
    final visited = List.filled(numCities, false);
    int currentCity = random.nextInt(numCities);

    path.add(currentCity);
    visited[currentCity] = true;

    while (path.length < numCities) {
      final nextCity = _selectNextCity(currentCity, visited);
      path.add(nextCity);
      visited[nextCity] = true;
      currentCity = nextCity;
    }

    return path;
  }

  int _selectNextCity(int currentCity, List<bool> visited) {
    final probabilities = List.filled(numCities, 0.0);
    double total = 0.0;

    for (int i = 0; i < numCities; i++) {
      if (!visited[i]) {
        probabilities[i] = (pow(pheromones[currentCity][i], alpha) * pow(1.0 / distances[currentCity][i], beta)) as double;
        total += probabilities[i];
      }
    }

    double r = random.nextDouble() * total;
    double sum = 0.0;
    for (int i = 0; i < numCities; i++) {
      if (!visited[i]) {
        sum += probabilities[i];
        if (sum >= r) {
          return i;
        }
      }
    }

    return -1; // Should not reach here
  }

  void run(int iterations) {
    var ants = initializeAnts();
    var bestAnt = ants.reduce((a, b) => a.pathLength < b.pathLength ? a : b);

    for (int iteration = 0; iteration < iterations; iteration++) {
      updatePheromones(ants);
      ants = List.generate(numAnts, (_) {
        final path = constructPath();
        final pathLength = _calculatePathLength(path);
        return Ant(path, pathLength);
      });

      final currentBestAnt = ants.reduce((a, b) => a.pathLength < b.pathLength ? a : b);
      if (currentBestAnt.pathLength < bestAnt.pathLength) {
        bestAnt = currentBestAnt;
      }

      print("Iteration ${iteration + 1}: Best Path Length = ${bestAnt.pathLength}");
    }

    print("Best Path: ${bestAnt.path}");
    print("Best Path Length: ${bestAnt.pathLength}");
  }
}

void main() {
  final distances = [
    [0.0, 2.0, 2.0, 3.0, 1.0],
    [2.0, 0.0, 4.0, 5.0, 3.0],
    [2.0, 4.0, 0.0, 6.0, 4.0],
    [3.0, 5.0, 6.0, 0.0, 5.0],
    [1.0, 3.0, 4.0, 5.0, 0.0],
  ];

  //We have cities A, B, C, D, E in x and the same in y
  //Each point mesure a distance between cities

                                    //nb ants, nb cities, distances , evaporation, alpha , beta
  final aco = AntColonyOptimization(10, 5, distances, 0.5, 1.0, 2.0);
  aco.run(100);


  /**
   *  Evaporation (ρ): This parameter (0 < ρ ≤ 1) controls the rate at which pheromone trails decrease over time, preventing unlimited accumulation and encouraging exploration of new paths. After each iteration, pheromone on each edge is updated as
   *   τ indice ij ← (1−ρ)τ indice ij+ Somme de k=1 à  m) Delta τ^k indice ij   .
   *   Alpha (α): This parameter controls the influence of the pheromone trail when ants choose their next city. Higher α means ants are more likely to follow stronger pheromone trails.
   *   Beta (β): This parameter controls the influence of heuristic information (e.g., inverse of distance between cities) during path selection. Higher β means ants rely more on the heuristic (like choosing shorter paths)
   *
   *   Ant Colony Optimization  ACO have a complexity of 0(iterations*m*n²)
   *   n : number of cities (nodes)
   *   m  : number of ants
   *   iterations : nb of
   *   Time /Space requirements of the algo grow proportionaly to the square of input size.
   */
}


// cf. L.M. Gambardella, E. Taillard, G. Agazzi, "MACS-VRPTW: A Multiple Ant Colony System for Vehicle Routing Problems with Time Windows", In D. Corne, M. Dorigo and F. Glover, editors, New Ideas in Optimization, McGraw-Hill, London, UK, pp. 63-76, 1999.
// cf. A. V. Donati, R. Montemanni, N. Casagrande, A. E. Rizzoli, L. M. Gambardella, "Time Dependent Vehicle Routing Problem with a Multi Ant Colony System
//Source : https://en.wikipedia.org/wiki/Ant_colony_optimization_algorithms#cite_note-L.M._Gambardella,_E._Taillard_pp._63-76-57