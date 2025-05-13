class BellmanFord {
  final int vertices;
  final List<Edge> edges;
  final List<int> distance;

  BellmanFord(this.vertices)
      : edges = [],
        distance = List.filled(vertices, 0);

  void addEdge(int from, int to, int weight) {
    edges.add(Edge(from, to, weight));
  }

  void addAllEdge(){}

  void bellmanFord(int source) {
    // Step 1: Initialize distances from the source to all other vertices as INFINITE
    for (int i = 0; i < vertices; i++) {
      distance[i] = i == source ? 0 : 1000000; // Using a large number to represent INFINITE
    }

    // Step 2: Relax all edges |V| - 1 times
    for (int i = 1; i < vertices; i++) {
      for (Edge edge in edges) {
        int u = edge.from;
        int v = edge.to;
        int weight = edge.weight;
        if (distance[u] != 1000000 && distance[u] + weight < distance[v]) {
          distance[v] = distance[u] + weight;
        }
      }
    }

    // Step 3: Check for negative-weight cycles
    for (Edge edge in edges) {
      int u = edge.from;
      int v = edge.to;
      int weight = edge.weight;
      if (distance[u] != 1000000 && distance[u] + weight < distance[v]) {
        print("Graph contains negative weight cycle");
        return;
      }
    }

    // Print the distances
    print("Vertex \t Distance from Source");
    for (int i = 0; i < vertices; i++) {
      print("$i \t\t ${distance[i]}");
    }
  }
}

class Edge {
  final int from;
  final int to;
  final int weight;

  Edge(this.from, this.to, this.weight);
}

void main() {
  BellmanFord graph = BellmanFord(5); // Create a graph with 5 vertices (or nb of nodes)

  // Add edges with weights
  graph.addEdge(0, 1, -1);
  graph.addEdge(0, 2, 4);
  graph.addEdge(1, 2, 3);
  graph.addEdge(1, 3, 2);
  graph.addEdge(1, 4, 2);
  graph.addEdge(3, 2, 5);
  graph.addEdge(3, 1, 1);
  graph.addEdge(4, 3, -3);

  graph.bellmanFord(0); // Run Bellman-Ford algorithm from source vertex 0
}
/*
  * Complexity : O(VE)
  * V: vertice
  * E: Edge
 */