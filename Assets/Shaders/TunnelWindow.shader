Shader "Custom/TunnelWindow"
{
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,1)
		_myDiffuse("Main Texture", 2D) = "white"

		_SRef("Stencil Ref", Float) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)]	_SComp("Stencil Comp", Float)	= 8
		[Enum(UnityEngine.Rendering.StencilOp)]	_SOp("Stencil Op", Float)		= 2
	}
   SubShader
	{
		Tags{ "Queue" = "Geometry-1" }
	
		ZWrite off
		ColorMask 0

		Stencil
		{
			Ref[_SRef]
			Comp[_SComp]	
			Pass[_SOp]	
		}

		CGPROGRAM
		#pragma surface surf Lambert
        
       	sampler2D _myDiffuse;

       	struct Input {
           	float2 uv_myDiffuse;
       	};
        
       	void surf (Input IN, inout SurfaceOutput o) 
		{
           	o.Albedo = float3(0,0,0);
        }
		ENDCG
	}
}
