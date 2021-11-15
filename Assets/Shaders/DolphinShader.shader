Shader "Custom/DolphinShader"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
		_Gloss("Gloss", Range(0,1)) = 0.5
		
		// World Reflection Cube map
		_WorldReflectionCubeMap("Cube Map", CUBE) = "white" {}
    }
    SubShader
    {
        CGPROGRAM

        #pragma surface surf BlinnPhong vertex:vert

        sampler2D _MainTex;
		half _BumpAmount;
		half _Spec;
		fixed _Gloss;
		samplerCUBE _WorldReflectionCubeMap;


        struct Input
        {
            float2 uv_MainTex;
			float3 vertColor;
			float3 worldRefl; INTERNAL_DATA
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
			
			float wave = sin(60*t + v.vertex.y * .8) * .1 +
                        sin(60*t*2 + v.vertex.y *.8*2) * .1;
						
			float wave2 = sin(60*t + v.vertex.x * .5) * .05 +
                        sin(60*t*2 + v.vertex.x *.5*2) * .05;
							
			v.vertex.x = v.vertex.x + wave;
			v.vertex.y = v.vertex.y + wave2;
			
			o.vertColor = wave + 2;
		}

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
			o.Gloss = _Gloss;
			o.Emission += texCUBE(_WorldReflectionCubeMap, WorldReflectionVector(IN, o.Normal)).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
