Shader "Custom/FishTankFloor"
{
	Properties
	{
        _myDiffuse ("Diffuse Texture", 2D) = "black" {}
		_BumpTex ("Bump Texture", 2D) = "white" {}
		_BumpAmount("Bump Amount", Range(0,20)) = 1
		_SmoothnessTex ("Smoothness Tex", 2D) = "white" {}
		_OcclusionTex ("Occlusion Tex", 2D) = "white" {}
	}
   SubShader
	{
		CGPROGRAM
			#pragma surface surf Standard 
        
        	sampler2D _myDiffuse;		
			sampler2D _BumpTex;
			half _BumpAmount;
			sampler2D _SmoothnessTex;
			sampler2D _OcclusionTex;
			sampler2D _SpecTex;
			half _Spec;

        	struct Input 
			{
            	float2 uv_myDiffuse;
				float2 uv_BumpTex;
				float2 uv_SmoothnessTex;
				float2 uv_OcclusionTex;
        	};
        
        	void surf (Input IN, inout SurfaceOutputStandard o) 
			{
            	o.Albedo = tex2D(_myDiffuse, IN.uv_myDiffuse).rgb;
						
				o.Normal = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex));
				o.Normal *= float3(_BumpAmount,_BumpAmount, 1);
			
				o.Smoothness = tex2D (_SmoothnessTex, IN.uv_SmoothnessTex).rgb;
			
				o.Occlusion = tex2D (_OcclusionTex, IN.uv_OcclusionTex).rgb;
        	}
		ENDCG
	}
	  FallBack "Diffuse"
}
