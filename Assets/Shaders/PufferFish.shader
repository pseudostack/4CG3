Shader "Custom/PufferFish"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_MainColor ("Albedo (RGB)", Color) = (1,1,1,1)
		_Amount ("Extrude", Range(-10,10)) = 0.01
		
		_SRef("Stencil Ref", Float) = 7
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

        fixed4 _MainColor;
        sampler2D _MainTex;

        struct Input
        {
			      float2 uv_MainTex;
        };

		struct appdata 
		{
			float4 vertex: POSITION;
			float3 normal: NORMAL;
			float4 texcoord: TEXCOORD0;
		};
		
		float _Amount;
			
	    void vert (inout appdata v) 
		{
			float t = _Time;
	        v.vertex.xyz += v.normal * sin(30*t) * _Amount ;
	    }
 
        void surf (Input IN, inout SurfaceOutput o)
        {
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex)*(_MainColor.rgb).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
