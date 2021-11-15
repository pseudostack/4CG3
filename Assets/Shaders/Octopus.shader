Shader "Custom/Octopus"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpTex ("Bump Texture", 2D) = "white" {}
		_BumpAmount("Bump Amount", Range(0,10)) = 1
		_Amount ("Extrude", Range(-1,1)) = 0.01
		
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
		sampler2D _BumpTex;
		half _BumpAmount;

        struct Input
        {
            float2 uv_MainTex;
				float2 uv_BumpTex;
        };

		struct appdata 
		{
			float4 vertex: POSITION;
			float3 normal: NORMAL;
			float4 texcoord: TEXCOORD0;
			float4 tangent: TANGENT;
		};
		
		float _Amount;
		
		void vert(inout appdata v) 
		{
			float t = _Time;
					
			float wave2 = sin(8*t + v.vertex.x * .5) * .05 +
						sin(8*t*2 + v.vertex.x *.5*2) * .05;
			
				
			v.vertex.x = v.vertex.x + wave2;		
		}

        void surf (Input IN, inout SurfaceOutput o)
        {

            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			
			//o.Normal = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex));
			
			//o.Normal *= float3(_BumpAmount,_BumpAmount, 1);

        }
        ENDCG
    }
    FallBack "Diffuse"
}
