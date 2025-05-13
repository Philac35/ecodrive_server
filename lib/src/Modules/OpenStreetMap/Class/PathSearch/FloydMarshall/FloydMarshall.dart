import 'dart:io';

class FloydWarshall {
  final int vertices;
  List<List<int>> dist;

  FloydWarshall(this.vertices) : dist = List.generate(vertices, (_) => List.filled(vertices, 0));

  void addEdge(int from, int to, int weight) {
    dist[from][to] = weight;
  }

  void floydWarshall() {
    for (int k = 0; k < vertices; k++) {
      for (int i = 0; i < vertices; i++) {
        for (int j = 0; j < vertices; j++) {
          if (dist[i][k] != 0 && dist[k][j] != 0 && (dist[i][j] == 0 || dist[i][j] > dist[i][k] + dist[k][j])) {
            dist[i][j] = dist[i][k] + dist[k][j];
          }
        }
      }
    }
  }

  void printSolution() {
    print("Shortest distances between every pair of vertices:");
    for (int i = 0; i < vertices; i++) {
      for (int j = 0; j < vertices; j++) {
        if (dist[i][j] == 0 && i != j) {
          stdout.write("INF ");
        } else {
          stdout.write("${dist[i][j]}   ");
        }
      }
      print("");
    }
  }
}

void main() {
  FloydWarshall graph = FloydWarshall(4); // Create a graph with 4 vertices

  // Add edges  (from,to,weight)
  graph.addEdge(0, 1, 5);
  graph.addEdge(0, 3, 10);
  graph.addEdge(1, 2, 3);
  graph.addEdge(2, 3, 1);

  graph.floydWarshall();
  graph.printSolution();
}
/*
  * Complexity : O(V^3)
  * V: vertice
 */