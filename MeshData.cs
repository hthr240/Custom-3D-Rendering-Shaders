using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class MeshData
{
    public List<Vector3> vertices; // The vertices of the mesh 
    public List<int> triangles; // Indices of vertices that make up the mesh faces
    public Vector3[] normals; // The normals of the mesh, one per vertex

    // Class initializer
    public MeshData()
    {
        vertices = new List<Vector3>();
        triangles = new List<int>();
    }

    // Returns a Unity Mesh of this MeshData that can be rendered
    public Mesh ToUnityMesh()
    {
        Mesh mesh = new Mesh
        {
            vertices = vertices.ToArray(),
            triangles = triangles.ToArray(),
            normals = normals
        };

        return mesh;
    }

    // Calculates surface normals for each vertex, according to face orientation
    public void CalculateNormals()
    {
        // create normal list for each triangle
        normals = new Vector3[vertices.Count];
        for (int i = 0; i < triangles.Count; i += 3)
        {
            int idx1 = triangles[i];
            int idx2 = triangles[i+1];
            int idx3 = triangles[i+2];

            Vector3 p1 = vertices[idx1];
            Vector3 p2 = vertices[idx2];
            Vector3 p3 = vertices[idx3];

            // calculate edges
            Vector3 edge1 = p2 - p1;
            Vector3 edge2 = p3 - p1;

            // get the cross product of the edges to find the face normal
            Vector3 normalForFace = Vector3.Cross(edge1,edge2);

            normals[idx1] += normalForFace;
            normals[idx2] += normalForFace;
            normals[idx3] += normalForFace;
            
        }

        for (int i = 0; i < normals.Length; i++)
        {
            normals[i].Normalize();
        }
    }

    // Edits mesh such that each face has a unique set of 3 vertices
    public void MakeFlatShaded()
    {
        // create new lists for vertices and triangles
        List<Vector3> newVertices = new List<Vector3>();
        List<int> newTriangles = new List<int>();

        for (int i = 0; i < triangles.Count; i++)
        {
            int oldVertexIdx = triangles[i];

            Vector3 vertexPos = vertices[oldVertexIdx];

            newVertices.Add(vertexPos);

            newTriangles.Add(newVertices.Count - 1);
        }

        // replace the 2 lists
        vertices = newVertices;
        triangles = newTriangles;

        // calculate normals
        CalculateNormals();
    }
}