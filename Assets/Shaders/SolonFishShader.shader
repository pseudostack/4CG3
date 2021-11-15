Shader "Custom/SolonFishShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		
		_SRef("Stencil Ref", Float) = 1
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

		#pragma surface surf Lambert vertex:vert

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
			float3 vertColor;
        };
		
		struct appdata 
		{
			float4 vertex: POSITION;
			float3 normal: NORMAL;
			float4 texcoord: TEXCOORD0;
		};

		void vert(inout appdata v, out Input o) 
		{
			UNITY_INITIALIZE_OUTPUT(Input,o);
			
			float t = _Time;
			
			float wave = sin(30*t + v.vertex.x * .1) * .3 +
                        sin(30*t*2 + v.vertex.x *.1*2) * .3;
						
			v.vertex.x = v.vertex.x + wave;
			v.normal = normalize(float3(v.normal.x + wave, v.normal.y, v.normal.z));
			o.vertColor = wave + 2;
		}

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
