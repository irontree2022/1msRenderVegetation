// Amplify Impostors
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

//#define HDRP10
using UnityEngine;
using UnityEngine.Rendering;

namespace AmplifyImpostors
{
	public class BakeHDRPTool
	{
#if HDRP10
		static UnityEngine.Rendering.HighDefinition.ShaderVariablesGlobal g_globalShaderVariables = new UnityEngine.Rendering.HighDefinition.ShaderVariablesGlobal();
		public static void SetupShaderVariableGlobals( Matrix4x4 viewMat, Matrix4x4 projMatrix , CommandBuffer commandBuffer )
		{
			g_globalShaderVariables._ViewMatrix = viewMat;
			g_globalShaderVariables._InvViewMatrix = viewMat.inverse;
			g_globalShaderVariables._ProjMatrix = projMatrix;
			g_globalShaderVariables._ViewProjMatrix = projMatrix * viewMat;
			g_globalShaderVariables._WorldSpaceCameraPos_Internal = Vector4.zero;
			ConstantBuffer.PushGlobal( commandBuffer, g_globalShaderVariables, UnityEngine.Rendering.HighDefinition.HDShaderIDs._ShaderVariablesGlobal );
		}
#else
			public static void SetupShaderVariableGlobals( Matrix4x4 viewMat, Matrix4x4 projMatrix , CommandBuffer commandBuffer ){/*This does nothing on HDRP lower that 10*/}
#endif
	}
}
