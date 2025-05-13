import 'dart:math';

class Particle {
  List<int> position;
  List<int> velocity;
  List<int> bestPosition;
  double bestFitness;

  Particle(this.position, this.velocity, this.bestPosition, this.bestFitness);
}

class ParticleSwarmOptimization {
  final int numParticles;
  final int numNodes;
  final List<List<double>> distances;
  final double inertiaWeight;
  final double cognitiveWeight;
  final double socialWeight;
  final Random random = Random();

  List<int> globalBestPosition;
  double globalBestFitness;

  ParticleSwarmOptimization(this.numParticles, this.numNodes, this.distances, this.inertiaWeight, this.cognitiveWeight, this.socialWeight)
      : globalBestPosition = List.filled(numNodes, 0),
        globalBestFitness = double.infinity;

  List<Particle> initializeParticles() {
    return List.generate(numParticles, (_) {
      final position = _generateRandomPath();
      final velocity = List.filled(numNodes, 0);
      return Particle(position, velocity, List.from(position), double.infinity);
    });
  }

  List<int> _generateRandomPath() {
    final path = List.generate(numNodes, (index) => index);
    path.shuffle(random);
    return path;
  }

  double calculateFitness(List<int> path) {
    double fitness = 0.0;
    for (int i = 0; i < path.length - 1; i++) {
      fitness += distances[path[i]][path[i + 1]];
    }
    fitness += distances[path.last][path.first]; // Return to the start node
    return fitness;
  }

  void updateParticles(List<Particle> particles) {
    for (final particle in particles) {
      for (int i = 0; i < numNodes; i++) {
        final r1 = random.nextDouble();
        final r2 = random.nextDouble();

        // Update velocity
        particle.velocity[i] = (inertiaWeight * particle.velocity[i] +
            cognitiveWeight * r1 * (particle.bestPosition[i] - particle.position[i]) +
            socialWeight * r2 * (globalBestPosition[i] - particle.position[i])).round();

        // Update position
        int newPosition = particle.position[i] + particle.velocity[i];
        newPosition = newPosition % numNodes; // Ensure the position is within bounds
        if (newPosition < 0) newPosition += numNodes;
        particle.position[i] = newPosition;
      }

      final fitness = calculateFitness(particle.position);
      if (fitness < particle.bestFitness) {
        particle.bestPosition = List.from(particle.position);
        particle.bestFitness = fitness;

        if (fitness < globalBestFitness) {
          globalBestPosition = List.from(particle.position);
          globalBestFitness = fitness;
        }
      }
    }
  }

  void run(int iterations) {
    var particles = initializeParticles();

    for (final particle in particles) {
      particle.bestFitness = calculateFitness(particle.position);
      if (particle.bestFitness < globalBestFitness) {
        globalBestPosition = List.from(particle.position);
        globalBestFitness = particle.bestFitness;
      }
    }

    for (int iteration = 0; iteration < iterations; iteration++) {
      updateParticles(particles);
      print("Iteration ${iteration + 1}: Global Best Fitness = $globalBestFitness");
    }

    print("Global Best Path: $globalBestPosition");
    print("Global Best Fitness: $globalBestFitness");
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

  final pso = ParticleSwarmOptimization(30, 5, distances, 0.7, 1.5, 1.5);
  pso.run(100);
}
