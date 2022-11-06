About

  Amplify Impostors (c) Amplify Creations, Lda. All rights reserved.

  Amplify Impostors is a component-based impostor creation tool for Unity 2017 and up

  Redistribution of Amplify Impostors is frowned upon. If you want to share the 
  software, please refer others to the official product page:

    http://amplify.pt/unity/amplify-impostors/

Description

 Amplify Impostors is a small but powerful tool that allows the creation of different
 types of Impostors, which are substitutes of complex high polycount objects made from flat
 and simple polygons, that render a fake version of the original object (hence the name). 
 Much like traditional sprites, they usually consist of a single flat quad polygon or simple
 polygonal shapes and, like classic billboards, always face the camera. Think of them as a
 camera facing cardboard version of the object you want to render. The common purpose of
 using such technique is to be able to represent far distant objects with a very low
 polycount, for instance, trees, bushes, rocks, ruins, buildings, props, etc. 

Features

  * 3 different pre-baked Impostor types
    * Spherical
    * Octahedron
    * HemiOctahedron
  * Realtime rendering
    * Scriptable Render Pipeline (HD and LW 4.9.0 and up)
    * Standard/Legacy Forward and Deferred rendering
    * Dynamic lights and shadows
    * Depth writing for object intersections
    * Global Illumination
    * GPU instancing
    * Dithering cross fade
  * Custom Shape Editor

Supported Platforms

  * All platforms 

Minimum Requirements

  Software

    Unity 2017+

Quick Guide Amplify Shader Editor
  1) (OPTIONAL) If using any SRP import the respective package found at "AmplifyImpostors > Plugins > EditorResources > RenderPipelinePackages"
  1.1) Please notice that for HDRP RenderPipelinePackages > Legacy > ImpostorsHDRP 9xx (Legacy) package holds compatibility up to SRP 9.x.x
  1.1) The package HDRP RenderPipelinePackages > ImpostorsHDRP is only compatible with  SRP 10.x.x 
  2) Select a game object in the scene or a prefab in your project
  3) In the inspector window search for and add the "Amplify Impostor" component
  4) Press "Bake Impostor" and select where you want to save the impostor files

Documentation

  Please refer to the following website for an up-to-date online manual:

    http://wiki.amplify.pt/index.php?title=Unity_Products:Amplify_Impostors/Manual

Feedback

  To file error reports, questions or suggestions, you may use 
  our feedback form online:

    http://amplify.pt/contact

  Or contact us directly:

    For general inquiries - info@amplify.pt
    For technical support - support@amplify.pt (customers only)

References

  Parts of this plugin were based on other works, namely:
    Octahedron Impostors by Ryan Brucks, https://shaderbits.com/blog/octahedral-impostors/
    Chapter 21. True Impostors by Eric Risser, https://developer.nvidia.com/gpugems/GPUGems3/gpugems3_ch21.html
    Real-time Realistic Rendering and Lighting of Forests by Eric Bruneton, Fabrice Neyret, https://hal.inria.fr/hal-00650120
