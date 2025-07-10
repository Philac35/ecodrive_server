import 'dart:math';

 //Traveling Salesman Pb
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

/*
 * Vehicle Routing Problem
 */
class VNS {
  final TSP tsp;
  final int maxIterations;

  VNS(this.tsp, this.maxIterations);

  TSPSolution solve() {
    TSPSolution currentSolution = tsp.generateInitialSolution();
    TSPSolution bestSolution = TSPSolution(List.from(currentSolution.tour), currentSolution.totalDistance);

    for (int iteration = 0; iteration < maxIterations; iteration++) {
      int k = 0;
      while (k < 2) { // We have 2 neighborhood structures
        TSPSolution newSolution = shaking(currentSolution, k);
        TSPSolution localSolution = localSearch(newSolution, k);

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

  TSPSolution localSearch(TSPSolution solution, int neighborhood) {
    List<int> tour = List.from(solution.tour);
    int bestDistance = solution.totalDistance;
    List<int> bestTour = List.from(tour);

    for (int i = 0; i < tour.length; i++) {
      for (int j = i + 1; j < tour.length; j++) {
        List<int> newTour;
        if (neighborhood == 0) {
          newTour = Neighborhoods.nodeSwap(tour, i, j);
        } else {
          newTour = Neighborhoods.twoOptSwap(tour, i, j);
        }

        int newDistance = tsp.calculateTotalDistance(newTour);
        if (newDistance < bestDistance) {
          bestDistance = newDistance;
          bestTour = List.from(newTour);
        }
      }
    }

    return TSPSolution(bestTour, bestDistance);
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
  VNS vns = VNS(tsp, 100); // 100 iterations
  TSPSolution bestSolution = vns.solve();

  print('Best Solution: $bestSolution');
}