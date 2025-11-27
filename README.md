# Custom 3D Shading & Rendering Engine | Unity HLSL

A custom 3D rendering pipeline implemented in **Unity** using **C#** and **HLSL (Cg)** shaders. This project builds a mesh processing engine from scratch (parsing OBJ files) and implements classic lighting models (**Blinn-Phong**, **Gouraud**) to demonstrate vertex vs. fragment shader operations.

## 🚀 Key Features
### 1. Custom Shader Library (HLSL)
* **Blinn-Phong Shading:** Implemented a per-pixel lighting model handling **Ambient**, **Diffuse**, and **Specular** (Shininess) components for realistic material rendering.
* **Gouraud Shading:** Implemented per-vertex lighting calculation to demonstrate performance optimizations and interpolation artifacts compared to Phong.
* **Multi-Light Support:** Engineered the shader to handle multiple point lights in a single pass, aggregating diffuse contributions.

### 2. Mesh Processing Engine (C#)
* **OBJ Loader:** Built a custom parser to read raw `.obj` files and reconstruct 3D meshes (Vertices, Triangles) at runtime.
* **Normal Calculation:** Implemented algorithms to compute **Face Normals** (via cross-product) and **Vertex Normals** (via averaging connected faces) for smooth shading.
* **Flat Shading:** Added functionality to decouple shared vertices, creating a "low-poly" flat-shaded aesthetic.

## 🛠️ Tech Stack
* **Engine:** Unity (2021+)
* **Shading Language:** HLSL / Cg
* **Scripting:** C#
* **Concepts:** Rendering Pipeline, Linear Algebra, Vector Calculus, Lighting Models.

## 📂 Project Structure
* `BlinnPhong.shader`: High-fidelity fragment shader calculating lighting per-pixel.
* `BlinnPhongGouraud.shader`: Optimized vertex shader calculating lighting per-vertex.
* `OBJParser.cs`: Reads text-based 3D model formats and converts them to Unity Mesh structures.
* `MeshData.cs`: Core data structure managing vertex buffers and normal recalculation logic.
* `MeshViewer.cs`: Controller script for loading models and switching shading modes at runtime.

## 🧠 Rendering Logic
The project contrasts two fundamental rendering approaches:
1.  **Vertex Shader (Gouraud):** Lighting is calculated $L = K_d (N \cdot L) + K_s (N \cdot H)^n$ at each **vertex**. The color is then interpolated across the triangle. Fast but inaccurate for specular highlights.
2.  **Fragment Shader (Blinn-Phong):** Normals are interpolated across the triangle, and the lighting equation is solved for every **pixel**. Computationally expensive but produces smooth, accurate highlights.
