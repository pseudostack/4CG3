Shader "Custom/MuschroomShader"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
		_BumpTex ("Normal Tex", 2D) = "white" {}
		_SpecTex ("Spec Tex", 2D) = "white" {}
		_Spec("Specular", Range(0,10)) = 0.5
				
		_BumpAmount("Bump Amount", Range(0,10)) = 1	
		_SpecColor("Specular", Color) = (1,1,1,1)
    }
    SubShader
    {
		
		Tags{"Queue" = "Geometry"}
		
        CGPROGRAM

        #pragma surface surf StandardSpecular

        sampler2D _MainTex;
		sampler2D _BumpTex;
		sampler2D _SpecTex;
		half _BumpAmount;
		half _Spec;
		fixed _Gloss;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_SpecTex;
			float2 uv_BumpTex;
        };
		
        void surf (Input IN, inout SurfaceOutputStandardSpecular o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
			
			o.Normal = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex));	
			o.Normal *= float3(_BumpAmount,_BumpAmount, 1);
			
			o.Smoothness = tex2D (_SpecTex, IN.uv_SpecTex).r * _Spec ;
			
			o.Specular = _SpecColor.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
