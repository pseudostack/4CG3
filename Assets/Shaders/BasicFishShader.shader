Shader "Custom/BasicFishShader"
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

        #pragma surface surf BlinnPhong vertex:vert

        sampler2D _MainTex;
		sampler2D _BumpTex;
		half _BumpAmount;
		half _Spec;
		fixed _Gloss;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_BumpTex;
			float3 vertColor;
        };
		
		struct appdata 
		{
			float4 vertex: POSITION;
			float3 normal: NORMAL;
			float4 texcoord: TEXCOORD0;
			float4 tangent : TANGENT;
		};

		void vert(inout appdata v, out Input o) 
		{
			UNITY_INITIALIZE_OUTPUT(Input,o);
			
			float t = _Time;
			
			float wave = sin(60*t + v.vertex.x * .12) * 1 +
                        sin(60*t*2 + v.vertex.x *.12*2) * 1;
						
			v.vertex.x = v.vertex.x + wave;
			v.normal = normalize(float3(v.normal.x + wave, v.normal.y, v.normal.z));
			o.vertColor = wave + 2;
		}


        void surf (Input IN, inout SurfaceOutput o)
        {

            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
			
			o.Normal = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex));
			o.Normal *= float3(_BumpAmount,_BumpAmount, 1);

			o.Gloss = _Gloss;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
