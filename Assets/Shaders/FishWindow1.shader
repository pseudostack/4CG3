Shader "Custom/FishWindow1"
{
	Properties
	{
		_myDiffuse ("Diffuse Texture", 2D) = "black" {}
		_BumpTex ("Bump Texture", 2D) = "white" {}
		_BumpAmount("Bump Amount", Range(0,20)) = 1
		
		_SmoothnessTex ("Smoothness Tex", 2D) = "white" {}
		_OcclusionTex ("Occlusion Tex", 2D) = "white" {}

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
		#pragma surface surf StandardSpecular
        
        sampler2D _myDiffuse;
			
		sampler2D _BumpTex;
		half _BumpAmount;
		sampler2D _SmoothnessTex;
		sampler2D _OcclusionTex;

        struct Input 
		{
           	float2 uv_myDiffuse;
			float2 uv_BumpTex;
			float2 uv_SmoothnessTex;
			float2 uv_OcclusionTex;
        };
        
        void surf (Input IN, inout SurfaceOutputStandardSpecular o) 
		{
           	o.Albedo = tex2D(_myDiffuse, IN.uv_myDiffuse).rgb;
							
			o.Normal = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex));	
			o.Normal *= float3(_BumpAmount,_BumpAmount, 1);
			
			o.Smoothness = tex2D (_SmoothnessTex, IN.uv_SmoothnessTex).rgb;
			
			o.Occlusion = tex2D (_OcclusionTex, IN.uv_OcclusionTex).rgb;
        	}
		ENDCG
	}
}
