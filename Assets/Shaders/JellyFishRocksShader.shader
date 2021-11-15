Shader "Custom/JellyFishRocksShader"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
		_BumpTex ("Normal Tex", 2D) = "white" {}
		_BumpAmount("Bump Amount", Range(0,10)) = 1
		_Gloss("Gloss", Range(0,1)) = 0.5
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf BlinnPhong

        sampler2D _MainTex;
		sampler2D _BumpTex;
	
		half _BumpAmount;
		fixed _Gloss;

        struct Input
        {
            float2 uv_MainTex;	
			float2 uv_BumpTex;
			float3 vertColor;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {

            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
			
			o.Normal = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex));
			o.Normal *= float3(_BumpAmount,_BumpAmount, 1);
			
			o.Specular = tex2D (_MainTex, IN.uv_MainTex);

			o.Gloss = _Gloss;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
