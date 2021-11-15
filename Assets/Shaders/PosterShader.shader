Shader "Custom/PosterShader"
{
	Properties
	{
        _myDiffuse ("Diffuse Texture", 2D) = "black" {}
	}
   SubShader
	{
		CGPROGRAM
		#pragma surface surf StandardSpecular
        
        sampler2D _myDiffuse;
			
       	struct Input {
           	float2 uv_myDiffuse;
       	};
        
       	void surf (Input IN, inout SurfaceOutputStandardSpecular o) 
		{
           	o.Albedo = tex2D(_myDiffuse, IN.uv_myDiffuse).rgb;
        }
		ENDCG
	}
	  FallBack "Diffuse"
}
