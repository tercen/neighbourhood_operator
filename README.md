# neighbourhood operator

##### Description

`neighbourhood` operator returns a neighbourhood enrichment of clusters of tissue cells. 

##### Usage

Input projection|.
---|---
`y-axis`        | numeric, input data, object numbers (from cell profiler for example)
`x-axis`        | numeric, input data, object numbers of neighbours (from cell profiler for example)
`color`         | character, input data, color by cluster label

Input Parameter |.
---|---
`permutation`   | numeric, number of permutations
`num of cores`  | numeric, number of cores
`seed`          | numeric, seed setting, -1 indicates random

Output relations|.
---|---
`p`             | numeric, p-value of enrichment for each cluster pair

##### Details

The operator takes as input the neighboorhood annotation of cells (i.e. object) aswell as the cluster label of the cells. The ouput is a p-value indicating how enriched (or depleted), in terms of neighbours, for each cluster to cluster relationship.
It uses the `neighbouRhood` code on the bodenmiller github location (https://github.com/BodenmillerGroup/neighbouRhood).

The neighbour relationship of the cells typically comes from Cell Profiler tool but any tool which generates cell neighbourhood information can be used. 

##### See Also

[clusterx_operator](https://github.com/tercen/clusterx_operator)
