Shader "Custom/RockShader"
{
	Properties
	{
        _myDiffuse ("Diffuse Texture", 2D) = "black" {}
		_BumpTex ("Bump Texture", 2D) = "white" {}
		_BumpAmount("Bump Amount", Range(0,20)) = 1
		
		_SpecTex ("Spec Tex", 2D) = "white" {}
		_Spec("Specular", Range(0,10)) = 0.5
		_SpecColor("Specular", Color) = (1,1,1,1)
				
		_SRef("Stencil Ref", Float) = 10
		[Enum(UnityEngine.Rendering.CompareFunction)]  _SComp("Stencil Comp", Float)   = 7
        [Enum(UnityEngine.Rendering.StencilOp)]        _SOp("Stencil Op", Float)      = 2

	}
   SubShader
	{
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
			
		sampler2D _SpecTex;
		half _Spec;

        struct Input 
		{
           	float2 uv_myDiffuse;
			float2 uv_BumpTex;
			float2 uv_SpecTex;
       	};
        
       	void surf (Input IN, inout SurfaceOutputStandardSpecular o) 
		{
           	o.Albedo = tex2D(_myDiffuse, IN.uv_myDiffuse).rgb;
									
			o.Normal = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex));	
			o.Normal *= float3(_BumpAmount,_BumpAmount, 1);
			
			o.Smoothness = tex2D (_SpecTex, IN.uv_SpecTex).r * _Spec ;
			
			o.Specular = _SpecColor.rgb;			
        	}
		ENDCG
	}
	  FallBack "Diffuse"
}
