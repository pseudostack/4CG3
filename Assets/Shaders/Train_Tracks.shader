Shader "Custom/Octopus"
{
    Properties
    {
		_RailColor ("Rail Color", Color) = (1,1,1)
		_BumpTex ("Bump Texture", 2D) = "white" {}
		_BumpAmount("Bump Amount", Range(0,20)) = 1
		_Gloss("Gloss", Range(0,10)) = 0.5
    }
    SubShader
    {
        CGPROGRAM

		#pragma surface surf BlinnPhong

        sampler2D _MainTex;
		sampler2D _BumpTex;
		half _BumpAmount;
		float3 _RailColor;
		fixed _Gloss;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_BumpTex;
        };

		float _Amount;
		
        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = _RailColor;
			
			o.Normal = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex));		
			o.Normal *= float3(_BumpAmount,_BumpAmount, 1);
			
			o.Gloss = _Gloss;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
