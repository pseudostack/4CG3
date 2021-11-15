Shader "Custom/FishInsideWindow"
{
	Properties
	{
        _myDiffuse ("Diffuse Texture", 2D) = "black" {}
		_BumpTex ("Normal Tex", 2D) = "white" {}
		_BumpAmount("Bump Amount", Range(0,10)) = 1
	}
   SubShader
	{
		CGPROGRAM
		#pragma surface surf Lambert
        
       	sampler2D _myDiffuse;
		sampler2D _BumpTex;
		half _BumpAmount;

       	struct Input 
		{
           	float2 uv_myDiffuse;
			float2 uv_BumpTex;
        };
        
        void surf (Input IN, inout SurfaceOutput o) 
		{
           	o.Albedo = tex2D(_myDiffuse, IN.uv_myDiffuse).rgb;
				
			o.Normal = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex));
			
			o.Normal *= float3(_BumpAmount,_BumpAmount, 1);
        }
		ENDCG
	}
}
