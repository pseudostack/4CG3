Shader "Custom/Train"
{
	Properties
	{
        _myDiffuse ("Diffuse Texture", 2D) = "black" {}
		
		_SRef("Stencil Ref", Float) = 12
        [Enum(UnityEngine.Rendering.CompareFunction)]  _SComp("Stencil Comp", Float)   = 8
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
		#pragma surface surf Lambert
        
       	sampler2D _myDiffuse;
		fixed _Gloss;
		float3 _Emission;
			
       	struct Input 
		{
           	float2 uv_myDiffuse;
        };
        
        void surf (Input IN, inout SurfaceOutput o) 
		{
           	o.Albedo = tex2D(_myDiffuse, IN.uv_myDiffuse).rgb;			
       	}
		ENDCG
	}
	  FallBack "Diffuse"
}
