//
//  GridNode.swift
//
//  Created by Zack Brown on 07/12/2020.
//

public struct GridNode: Codable, Equatable, Hashable {
    
    let coordinate: Coordinate
    let cardinal: Cardinal
}


/*
 public GridPath Path(GridCoordinate origin, GridCoordinate destination) {

     List<GridCoordinate> nodes = new List<GridCoordinate>();

     if(!origin.Equals(destination)) {

         PriorityQueue<GridCoordinate> queue = new PriorityQueue<GridCoordinate>();

         Dictionary<GridCoordinate, GridCoordinate> vectors = new Dictionary<GridCoordinate, GridCoordinate>();
         Dictionary<GridCoordinate, float> cost = new Dictionary<GridCoordinate, float>();

         queue.Enqueue(origin, 0.0f);

         vectors[origin] = origin;
         cost[origin] = 0.0f;

         while(queue.Count > 0) {

             GridCoordinate vector = queue.Dequeue();

             if(vector.Equals(destination)) {

                 GridCoordinate node = destination;

                 nodes.Add(node);

                 while(!node.Equals(origin)) {

                     node = vectors[node];

                     nodes.Add(node);
                 }

                 nodes.Reverse();

                 break;
             }

             AreaNode areaNode = area.FindNode(vector);
             FootpathNode footpathNode = footpath.FindNode(vector);

             ITraversable traversable = areaNode;

             if(areaNode == null) {

                 traversable = footpathNode;
             }

             if(traversable != null) {

                 for(int index = 0; index < 4; index++) {

                     GridEdge edge = (GridEdge)index;

                     if(traversable.Border(edge) != TraversableBorder.Closed) {

                         int toll = traversable.Toll(edge);

                         Vector3 normal = GridEdges.Normal(edge);

                         GridCoordinate neighbour = new GridCoordinate((vector.x + (int)normal.x), vector.y, (vector.z + (int)normal.z));

                         if(!vectors.ContainsKey(neighbour) || toll < cost[neighbour]) {

                             float priority = (toll + traversable.Heuristic(destination));

                             queue.Enqueue(neighbour, priority);

                             vectors[neighbour] = vector;
                             cost[neighbour] = toll;
                         }
                     }
                 }
             }
         }
     }

     return new GridPath(origin, destination, nodes.ToArray());
 }
 
 
 return Mathf.Abs(polyhedron.volume.coordinate.x - coordinate.x) + Mathf.Abs(polyhedron.volume.coordinate.z - coordinate.z);
 
 */
