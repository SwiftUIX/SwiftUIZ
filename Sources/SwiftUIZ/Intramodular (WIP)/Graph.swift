/*//
// Copyright (c) Vatsal Manot
//


import Foundation

// Define a struct representing an edge in the graph
struct GraphEdge<NodeIdentifier: Hashable> {
    let source: NodeIdentifier
    let destination: NodeIdentifier
    
    init(source: NodeIdentifier, destination: NodeIdentifier) {
        self.source = source
        self.destination = destination
    }
}

// Define a class for graph nodes
class GraphNode<NodeIdentifier: Hashable> {
    let identifier: NodeIdentifier
    var data: AnyHashable
    var neighbors: [GraphEdge<NodeIdentifier>]
    
    init(identifier: NodeIdentifier, data: AnyHashable) {
        self.identifier = identifier
        self.data = data
        self.neighbors = []
    }
}

// Define an enum for graph direction
enum Direction {
    case directed
    case undirected
}

// Define a generic class for the graph
class Graph<NodeIdentifier: Hashable> {
    var nodeMap: [NodeIdentifier: GraphNode<NodeIdentifier>] = [:]
    let direction: Direction
    
    init(direction: Direction) {
        self.direction = direction
    }
    
    var nodes: [GraphNode<NodeIdentifier>] {
        return Array(nodeMap.values)
    }
    
    func addNode(_ node: GraphNode<NodeIdentifier>) {
        nodeMap[node.identifier] = node
    }
    
    func addEdge(from source: NodeIdentifier, to destination: NodeIdentifier) {
        guard let sourceNode = nodeMap[source], let destinationNode = nodeMap[destination] else {
            return
        }
        
        let edge = GraphEdge(source: source, destination: destination)
        sourceNode.neighbors.append(edge)
        
        if direction == .undirected {
            let reverseEdge = GraphEdge(source: destination, destination: source)
            destinationNode.neighbors.append(reverseEdge)
        }
    }
    
    func removeNode(_ node: GraphNode<NodeIdentifier>) {
        nodeMap.removeValue(forKey: node.identifier)
        
        for otherNode in nodes {
            otherNode.neighbors.removeAll { $0.destination == node.identifier }
        }
    }
    
    func findShortestPath(from source: NodeIdentifier, to destination: NodeIdentifier) -> [NodeIdentifier]? {
        // Implement breadth-first search (BFS) to find the shortest path
        var visited: Set<NodeIdentifier> = []
        var queue: [(NodeIdentifier, [NodeIdentifier])] = [(source, [source])]
        
        while !queue.isEmpty {
            let (currentNode, path) = queue.removeFirst()
            
            if currentNode == destination {
                return path
            }
            
            visited.insert(currentNode)
            
            guard let node = nodeMap[currentNode] else {
                continue
            }
            
            for neighbor in node.neighbors {
                if !visited.contains(neighbor.destination) {
                    queue.append((neighbor.destination, path + [neighbor.destination]))
                }
            }
        }
        
        return nil
    }
    
    var connectedComponents: [[GraphNode<NodeIdentifier>]] {
        var visited: Set<NodeIdentifier> = []
        var components: [[GraphNode<NodeIdentifier>]] = []
        
        for node in nodes {
            if !visited.contains(node.identifier) {
                var component: [GraphNode<NodeIdentifier>] = []
                var stack: [GraphNode<NodeIdentifier>] = [node]
                
                while !stack.isEmpty {
                    let currentNode = stack.removeLast()
                    visited.insert(currentNode.identifier)
                    component.append(currentNode)
                    
                    for neighbor in currentNode.neighbors {
                        if !visited.contains(neighbor.destination),
                           let neighborNode = nodeMap[neighbor.destination] {
                            stack.append(neighborNode)
                        }
                    }
                }
                
                components.append(component)
            }
        }
        
        return components
    }
}

// Define a context class for pattern matching
class PatternMatchingContext<NodeIdentifier: Hashable> {
    var captureGroups: [String: GraphNode<NodeIdentifier>] = [:]
}

// Define a struct representing a match result
struct MatchResult<NodeIdentifier: Hashable> {
    let rootNode: GraphNode<NodeIdentifier>
    let capturedNodes: [String: GraphNode<NodeIdentifier>]
}

protocol PatternCondition<NodeIdentifier> {
    associatedtype NodeIdentifier: Hashable
    
    func isSatisfied(
        by node: GraphNode<NodeIdentifier>,
        in graph: Graph<NodeIdentifier>,
        context: PatternMatchingContext<NodeIdentifier>
    ) -> Bool
}

protocol PrimitivePatternCondition<NodeIdentifier>: PatternCondition {
    func isSatisfied(
        by node: GraphNode<NodeIdentifier>,
        in graph: Graph<NodeIdentifier>,
        context: PatternMatchingContext<NodeIdentifier>
    ) -> Bool
}

struct OptionalSubpatternCondition<NodeIdentifier: Hashable>: PrimitivePatternCondition {
    let subpattern: Pattern<NodeIdentifier>
    
    func isSatisfied(
        by node: GraphNode<NodeIdentifier>,
        in graph: Graph<NodeIdentifier>,
        context: PatternMatchingContext<NodeIdentifier>
    ) -> Bool {
        if let _ = graph.findMatchingSubgraph(for: subpattern, startingFrom: node, context: context) {
            return true
        }
        return true
    }
}

struct AlternativeSubpatternsCondition<NodeIdentifier: Hashable>: PrimitivePatternCondition {
    let subpatterns: [Pattern<NodeIdentifier>]
    
    func isSatisfied(
        by node: GraphNode<NodeIdentifier>,
        in graph: Graph<NodeIdentifier>,
        context: PatternMatchingContext<NodeIdentifier>
    ) -> Bool {
        for subpattern in subpatterns {
            if let _ = graph.findMatchingSubgraph(for: subpattern, startingFrom: node, context: context) {
                return true
            }
        }
        return false
    }
}

struct QuantifiedSubpatternCondition<NodeIdentifier: Hashable>: PrimitivePatternCondition {
    let subpattern: Pattern<NodeIdentifier>
    let occurrences: ClosedRange<Int>
    
    func isSatisfied(
        by node: GraphNode<NodeIdentifier>,
        in graph: Graph<NodeIdentifier>,
        context: PatternMatchingContext<NodeIdentifier>
    ) -> Bool {
        var count = 0
        var visited: Set<NodeIdentifier> = []
        
        func dfs(_ node: GraphNode<NodeIdentifier>) {
            visited.insert(node.identifier)
            
            if let _ = graph.findMatchingSubgraph(for: subpattern, startingFrom: node, context: context) {
                count += 1
            }
            
            for edge in node.neighbors {
                if let neighbor = graph.nodeMap[edge.destination], !visited.contains(neighbor.identifier) {
                    dfs(neighbor)
                }
            }
        }
        
        dfs(node)
        
        return occurrences.contains(count)
    }
}

struct CustomPredicateCondition<NodeIdentifier: Hashable>: PatternCondition {
    let predicate: (GraphNode<NodeIdentifier>, Graph<NodeIdentifier>, PatternMatchingContext<NodeIdentifier>) -> Bool
    
    func isSatisfied(
        by node: GraphNode<NodeIdentifier>,
        in graph: Graph<NodeIdentifier>,
        context: PatternMatchingContext<NodeIdentifier>
    ) -> Bool {
        return predicate(node, graph, context)
    }
}

struct Pattern<NodeIdentifier: Hashable> {
    let identifier: String
    let conditions: [any PatternCondition<NodeIdentifier>]
    let subpatterns: [(pattern: Pattern<NodeIdentifier>, isOptional: Bool, occurrences: ClosedRange<Int>)]
    let captureGroups: [String: String]?
    
    func matches(_ node: GraphNode<NodeIdentifier>, in graph: Graph<NodeIdentifier>, context: PatternMatchingContext<NodeIdentifier>) -> MatchResult<NodeIdentifier>? {
        var capturedNodes: [String: GraphNode<NodeIdentifier>] = [:]
        
        for condition in conditions {
            if let primitiveCondition = condition as? any PrimitivePatternCondition<NodeIdentifier> {
                if !primitiveCondition.isSatisfied(by: node, in: graph, context: context) {
                    return nil
                }
            } else {
                if !condition.isSatisfied(by: node, in: graph, context: context) {
                    return nil
                }
            }
        }
        
        capturedNodes[identifier] = node
        
        for (subpattern, isOptional, occurrences) in subpatterns {
            var subgraphMatches: [MatchResult<NodeIdentifier>] = []
            
            for edge in node.neighbors {
                if let neighbor = graph.nodeMap[edge.destination],
                   let subgraphMatch = subpattern.matches(neighbor, in: graph, context: context) {
                    subgraphMatches.append(subgraphMatch)
                }
            }
            
            let matchCount = subgraphMatches.count
            if occurrences.contains(matchCount) {
                for subgraphMatch in subgraphMatches {
                    capturedNodes.merge(subgraphMatch.capturedNodes) { (current, _) in current }
                }
            } else if !isOptional {
                return nil
            }
        }
        
        if let captureGroups = captureGroups {
            for (captureGroup, nodeIdentifier) in captureGroups {
                if let capturedNode = capturedNodes[nodeIdentifier] {
                    context.captureGroups[captureGroup] = capturedNode
                }
            }
        }
        
        return MatchResult(rootNode: node, capturedNodes: capturedNodes)
    }
}

extension Graph {
    func findMatches(
        for pattern: Pattern<NodeIdentifier>
    ) -> [MatchResult<NodeIdentifier>] {
        var matches: [MatchResult<NodeIdentifier>] = []
        let context = PatternMatchingContext<NodeIdentifier>()
        
        for node in nodes {
            if let match = pattern.matches(node, in: self, context: context) {
                matches.append(match)
            }
            
            let subMatches = findMatchesInSubgraph(for: pattern, startingFrom: node, context: context)
            matches.append(contentsOf: subMatches)
        }
        
        return matches
    }
    
    func findMatchesInSubgraph(
        for pattern: Pattern<NodeIdentifier>,
        startingFrom node: GraphNode<NodeIdentifier>,
        context: PatternMatchingContext<NodeIdentifier>
    ) -> [MatchResult<NodeIdentifier>] {
        var matches: [MatchResult<NodeIdentifier>] = []
        var visited: Set<NodeIdentifier> = []
        
        func dfs(_ node: GraphNode<NodeIdentifier>) {
            visited.insert(node.identifier)
            
            if let match = pattern.matches(node, in: self, context: context) {
                matches.append(match)
            }
            
            for edge in node.neighbors {
                if let neighbor = nodeMap[edge.destination], !visited.contains(neighbor.identifier) {
                    dfs(neighbor)
                }
            }
        }
        
        dfs(node)
        
        return matches
    }
    
    func findMatchingSubgraph(
        for pattern: Pattern<NodeIdentifier>,
        startingFrom node: GraphNode<NodeIdentifier>,
        context: PatternMatchingContext<NodeIdentifier>
    ) -> MatchResult<NodeIdentifier>? {
        var visited: Set<NodeIdentifier> = []
        
        func dfs(_ node: GraphNode<NodeIdentifier>) -> MatchResult<NodeIdentifier>? {
            visited.insert(node.identifier)
            
            if let match = pattern.matches(node, in: self, context: context) {
                return match
            }
            
            for edge in node.neighbors {
                if let neighbor = nodeMap[edge.destination], !visited.contains(neighbor.identifier),
                   let subgraphMatch = dfs(neighbor) {
                    return subgraphMatch
                }
            }
            
            return nil
        }
        
        return dfs(node)
    }
}

// Define a struct for graph difference
struct GraphDifference<NodeIdentifier: Hashable> {
    let added: [GraphNode<NodeIdentifier>]
    let removed: [GraphNode<NodeIdentifier>]
    let modified: [GraphNode<NodeIdentifier>]
    
    var hasChanges: Bool {
        return !added.isEmpty || !removed.isEmpty || !modified.isEmpty
    }
}

// Extension to add the diff function to the Graph class
extension Graph {
    func diff(_ other: Graph<NodeIdentifier>) -> GraphDifference<NodeIdentifier> {
        var added: [GraphNode<NodeIdentifier>] = []
        var removed: [GraphNode<NodeIdentifier>] = []
        var modified: [GraphNode<NodeIdentifier>] = []
        
        // Check for added nodes
        for node in other.nodes {
            if nodeMap[node.identifier] == nil {
                added.append(node)
            }
        }
        
        // Check for removed nodes
        for node in nodes {
            if other.nodeMap[node.identifier] == nil {
                removed.append(node)
            }
        }
        
        // Check for modified nodes
        for node in nodes {
            if let otherNode = other.nodeMap[node.identifier], node.data != otherNode.data {
                modified.append(node)
            }
        }
        
        return GraphDifference(added: added, removed: removed, modified: modified)
    }
}
*/
