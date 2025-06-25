import 'dart:collection';
import 'dart:io';

/*
 * Breadth-First Algorithm
 * Useful for unweighted graphs and can be extended for various applications like finding the shortest path in an unweighted graph, web crawling, social network analysis, etc.
 */
class BFSalgorithm {
  int vertices;
  List<List<int>> adjacencyList;

  BFSalgorithm(this.vertices)
      : adjacencyList = List.generate(vertices, (_) => <int>[]);

  void addEdge(int from, int to) {
    adjacencyList[from].add(to);
  }

  void bfs(int start) {
    List<bool> visited = List.filled(vertices, false);
    Queue<int> queue = Queue<int>();

    visited[start] = true;
    queue.add(start);

    while (queue.isNotEmpty) {
      int current = queue.removeFirst();
      stdout.write('$current ');

      for (var neighbor in adjacencyList[current]) {
        if (!visited[neighbor]) {
          visited[neighbor] = true;
          queue.add(neighbor);
        }
      }
    }
  }
}

void main() {
  BFSalgorithm graph = BFSalgorithm(7);
  graph.addEdge(0, 1);
  graph.addEdge(0, 2);
  graph.addEdge(1, 3);
  graph.addEdge(1, 4);
  graph.addEdge(2, 5);
  graph.addEdge(2, 6);

  print('Breadth-First Search (BFS) traversal starting from vertex 0:');
  graph.bfs(0);
}
/*
  * Complexity : O(V+E)
  * V: vertice
  * E: Edge
 */