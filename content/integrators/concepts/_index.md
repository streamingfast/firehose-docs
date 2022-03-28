---
weight: 30
title: Concepts & Code Overview
sideNavRoot: true
menu:
  integrators:
    name: Concepts
    identifier: concepts
    weight: 10
---

This section aims to be the best way to fully understand the power of the Firehose system, its architecture,
the various components that it's made of, and how data flows through the Firehose stack up to the final consumer
through the gRPC connection.

---

![firehose](/drawings/firehose-architecture.svg)


This is a test mermaid drawing, please remove me:

{{< mermaid >}}
graph LR;
   A[sheets ream<sup>-1</sup> <br> 500] -->|-1| B[thickness <br> 10<sup>-2</sup>cm <br>]
   C[thickness ream<sup>-1</sup> <br> 5cm] --> B
   B --> D[volume <br> 1cm<sup>3</sup>]
   E[height <br> 6cm] --> D
   F[width <br> 15cm] --> D
{{< /mermaid >}}

---

In the following pages, we'll cover:

- [Goals and Motivations](/operators/concepts/goals/)
- [Principles and Approach](/operators/concepts/principles/)
- [Data Flow](/operators/concepts/data-flow/)
- [Components](/operators/concepts/components/)
- [Data Stores and Artifacts](/operators/concepts/data-stores-artifacts/)
