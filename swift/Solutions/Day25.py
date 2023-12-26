from math import prod

import networkx

def solve(file):
    graph = networkx.Graph()

    with open(file) as input:
        for line in input:
            vertex, neighbours = line.split(": ")
            for neighbour in neighbours.strip().split(" "):
                graph.add_edge(vertex, neighbour)

    edgesToRemove = networkx.minimum_edge_cut(graph)
    graph.remove_edges_from(edgesToRemove)

    answer = 1

    for group in networkx.connected_components(graph):
        answer *= len(group)
    return answer

assert(solve("../Resources/Day25/ExamplePart1In.txt") == 54)
print(solve("../Resources/Day25/Part1In.txt"))
