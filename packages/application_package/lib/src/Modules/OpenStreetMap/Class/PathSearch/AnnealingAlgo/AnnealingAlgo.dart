
import 'dart:math';
//Anneling  is a Traveler Salesman Pb Based
class TSPSolution {
  List<int> tour;
  int totalDistance;

  TSPSolution(this.tour, this.totalDistance);

  @override
  String toString() {
    return 'Tour: $tour, Distance: $totalDistance';
  }
}

class TSP {
  final List<List<int>> distanceMatrix;
  final int numberOfNodes;

  TSP(this.distanceMatrix) : numberOfNodes = distanceMatrix.length;

  int calculateTotalDistance(List<int> tour) {
    int totalDistance = 0;
    for (int i = 0; i < tour.length - 1; i++) {
      totalDistance += distanceMatrix[tour[i]][tour[i + 1]];
    }
    totalDistance += distanceMatrix[tour.last][tour.first]; // Return to start
    return totalDistance;
  }

  TSPSolution generateInitialSolution() {
    List<int> tour = List.generate(numberOfNodes, (index) => index);
    tour.shuffle();
    int totalDistance = calculateTotalDistance(tour);
    return TSPSolution(tour, totalDistance);
  }
}

class Neighborhoods {
  static List<int> nodeSwap(List<int> tour, int i, int j) {
    List<int> newTour = List.from(tour);
    int temp = newTour[i];
    newTour[i] = newTour[j];
    newTour[j] = temp;
    return newTour;
  }

  static List<int> twoOptSwap(List<int> tour, int i, int j) {
    List<int> newTour = List.from(tour);
    while (i < j) {
      int temp = newTour[i];
      newTour[i] = newTour[j];
      newTour[j] = temp;
      i++;
      j--;
    }
    return newTour;
  }
}

class SimulatedAnnealing {
  final TSP tsp;
  final double initialTemperature;
  final double coolingRate;
  final int iterationsPerTemperature;

  SimulatedAnnealing(this.tsp, this.initialTemperature, this.coolingRate, this.iterationsPerTemperature);

  TSPSolution solve(TSPSolution initialSolution) {
    TSPSolution currentSolution = initialSolution;
    TSPSolution bestSolution = TSPSolution(List.from(currentSolution.tour), currentSolution.totalDistance);

    double temperature = initialTemperature;

    while (temperature > 1) {
      for (int i = 0; i < iterationsPerTemperature; i++) {
        TSPSolution newSolution = getRandomNeighbor(currentSolution);

        int delta = newSolution.totalDistance - currentSolution.totalDistance;

        if (delta < 0 || Random().nextDouble() < exp(-delta / temperature)) {
          currentSolution = newSolution;

          if (currentSolution.totalDistance < bestSolution.totalDistance) {
            bestSolution = TSPSolution(List.from(currentSolution.tour), currentSolution.totalDistance);
          }
        }
      }
      temperature *= coolingRate;
    }

    return bestSolution;
  }

  TSPSolution getRandomNeighbor(TSPSolution solution) {
    List<int> tour = List.from(solution.tour);
    Random random = Random();

    int i = random.nextInt(tour.length);
    int j = random.nextInt(tour.length);

    if (random.nextBool()) {
      tour = Neighborhoods.nodeSwap(tour, i, j);
    } else {
      if (i > j) {
        int temp = i;
        i = j;
        j = temp;
      }
      tour = Neighborhoods.twoOptSwap(tour, i, j);
    }

    int totalDistance = tsp.calculateTotalDistance(tour);
    return TSPSolution(tour, totalDistance);
  }
}

class VNS {
  final TSP tsp;
  final int maxIterations;
  final SimulatedAnnealing sa;

  VNS(this.tsp, this.maxIterations, this.sa);

  TSPSolution solve() {
    TSPSolution currentSolution = tsp.generateInitialSolution();
    TSPSolution bestSolution = TSPSolution(List.from(currentSolution.tour), currentSolution.totalDistance);

    for (int iteration = 0; iteration < maxIterations; iteration++) {
      int k = 0;
      while (k < 2) { // We have 2 neighborhood structures
        TSPSolution newSolution = shaking(currentSolution, k);
        TSPSolution localSolution = sa.solve(newSolution);

        if (localSolution.totalDistance < currentSolution.totalDistance) {
          currentSolution = localSolution;
          if (currentSolution.totalDistance < bestSolution.totalDistance) {
            bestSolution = TSPSolution(List.from(currentSolution.tour), currentSolution.totalDistance);
          }
          k = 0;
        } else {
          k++;
        }
      }
    }

    return bestSolution;
  }

  TSPSolution shaking(TSPSolution solution, int neighborhood) {
    List<int> tour = List.from(solution.tour);
    Random random = Random();

    if (neighborhood == 0) {
      // Node Swap
      int i = random.nextInt(tour.length);
      int j = random.nextInt(tour.length);
      tour = Neighborhoods.nodeSwap(tour, i, j);
    } else if (neighborhood == 1) {
      // 2-opt Swap
      int i = random.nextInt(tour.length);
      int j = random.nextInt(tour.length);
      if (i > j) {
        int temp = i;
        i = j;
        j = temp;
      }
      tour = Neighborhoods.twoOptSwap(tour, i, j);
    }

    int totalDistance = tsp.calculateTotalDistance(tour);
    return TSPSolution(tour, totalDistance);
  }
}

void main() {
  List<List<int>> distanceMatrix = [
    [0, 2, 3, 4, 5],
    [2, 0, 4, 3, 4],
    [3, 4, 0, 2, 3],
    [4, 3, 2, 0, 2],
    [5, 4, 3, 2, 0]
  ];

  TSP tsp = TSP(distanceMatrix);
  SimulatedAnnealing sa = SimulatedAnnealing(tsp, 1000.0, 0.95, 100);
  VNS vns = VNS(tsp, 100, sa); // 100 iterations
  TSPSolution bestSolution = vns.solve();

  print('Best Solution: $bestSolution');
}

/*
  *Complexity : O(iterations * n² ) or worse
 */