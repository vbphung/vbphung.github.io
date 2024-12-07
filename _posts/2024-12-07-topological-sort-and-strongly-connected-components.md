---
layout: post
title: Topological Sort and Strongly Connected Components
date: 2024-12-07
---

<script type="text/javascript" async  
     src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js">  
</script>

This blog is about [Advent of Code 2024 - Day 5](https://adventofcode.com/2024/day/5), Part 2 of which must be solved using Topological Sort. However, I solved it by brute force and then was coincidentally taught about Topological Sort that same night.

I also found [a similar blog](https://abhamra.com/blog/aoc24day5/) that sounds more interesting than what I'm going to write here.

**TODO** - add some illustrations

# DAG and Topological Sort

A Directed Acyclic Graph (DAG), as its name suggests, is a directed graph with no cycles and has practical applications:

- **Data processing** - IPFS uses DAG to represent its hierarchical data structure.
- **Task scheduling** - DAG can be used to sequence tasks while respecting all precedence constraints.
- **Dependency resolution**... you name it.

Regarding the Topological Ordering of a DAG $$G$$, it's a linear ordering of its vertices such that for all $$u$$ and $$v$$ of edge $$(u, v)$$ in $$G$$, $$u$$ comes before $$v$$. From this definition, we can see that Part 2 of AOC2024 - Day 5 is purely about implementing Topological Sort.

## My Topo Implementation

There is more than one way to implement Topological Sort: DFS-based and Kahn's algorithm. I personally prefer the former because of its simplicity and better understandability.

First, we have to eliminate all tasks that aren't included in the `update`:

```rust
let mut graph: Vec<Vec<usize>> = vec![Vec::new(); n];
for (u, vs) in dag.iter().enumerate() {
    if !update.contains(u) {
        continue;
    }

    for &v in vs {
        if update.contains(v) {
            graph[u].push(v);
        }
    }
}
```

Then, everything comes down to your familiar DFS [but we twisted it a bit](https://www.youtube.com/watch?v=tmzZTKMrW7Y). Continuing from the above code snippet:

```rust
let mut ans = Vec::new();
let mut explored = BitSet::with_capacity(n);
for &u in order {
    dfs(&graph, &mut explored, &mut ans, u);
}
```

And here is the `dfs` function:

```rust
fn dfs(graph: &[Vec<usize>], explored: &mut BitSet, ins: &mut Vec<usize>, u: usize) {
    if explored.contains(u) {
        return;
    }

    explored.insert(u);

    if let Some(vs) = graph.get(u) {
        for &v in vs {
            dfs(graph, explored, ins, v);
        }
    }

    ins.push(u);
}
```

You can find the full code [here](https://github.com/vbphung/aoc-2024/blob/main/day_5/src/recur_topo.rs) and even [its Kahn's version](https://github.com/vbphung/aoc-2024/blob/e901b52c6c7813f7cc1bad8314a851c197cac74b/day_5/src/main.rs#L71).

# Strongly Connected Components

We first define the equivalence relation between two vertices $$u$$ and $$v$$: $$u \sim v$$ iff there exists a path from $$u$$ to $$v$$ and vice versa. A Strongly Connected Component (SCC) is a maximal set of vertices that are equivalent to each other, or an equivalence class.

One algorithm to find SCCs is Kosaraju's Two-Pass, which also leverages DFS:

- **1st pass** - Run DFS on the **reverse** graph to compute the finishing time of each vertex.

```cpp
void finish_dfs(const std::vector<std::vector<int>> &rev,
                std::bitset<N> &explored, std::vector<int> &fns, int &t,
                int u) {
    if (explored.test(u)) {
        return;
    }

    explored.set(u);

    for (auto v : rev[u]) {
        finish_dfs(rev, explored, fns, t, v);
    }

    fns[t++] = u;
}
```

- **2nd pass** - Run DFS on the original graph in decreasing order of finishing time.

```cpp
void sccs_dfs(const std::vector<std::vector<int>> &arcs,
              std::bitset<N> &explored, std::vector<int> &leaders, int t,
              int u) {
    if (explored.test(u)) {
        return;
    }

    explored.set(u);
    leaders[u] = t;

    for (auto v : arcs[u]) {
        sccs_dfs(arcs, explored, leaders, t, v);
    }
}
```

# Complexity

By leveraging DFS, both Topological Sort and SCCs can be done in linear time, $$O(V + E)$$, where $$V$$ and $$E$$ are the number of vertices and edges, respectively.
