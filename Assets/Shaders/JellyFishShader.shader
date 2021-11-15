Shader "Custom/JellyFishShader"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
		_BumpAmount("Bump Amount", Range(0,10)) = 1
		
		//slider
		_RimSlider("Slider", Range(0,5)) = 1
		
		//color picker (emission)
		_myEmission("Emission Color Picker", Color) = (1,1,1,1)
		
		_OutlineColor ("Outline Color", Color) = (0,0,0,1)
		_Outline ("Outline Width", Range (.002, 1)) = .005
	  
		_AlphaSlider("Alpha Slider", Range (0.005, 5)) = 0
    }
    SubShader
    {
		Tags{"Queue" = "Transparent"}
		
        CGPROGRAM

		#pragma surface surf Lambert vertex:vert alpha:fade

        sampler2D _MainTex;
		
		half _RimSlider;
		half _AlphaSlider;
		
		fixed4 _myEmission;
		
		float _Outline;
	    float4 _OutlineColor;

        struct Input
        {
            float2 uv_MainTex;
			float3 vertColor;
			
			float3 viewDir;
			float3 worldPos;
					
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
			float movement = sin(t*20) * .8;
			v.vertex.yx += v.normal *movement < -.9 ?  float(-.9): movement;
			
			float wave = sin(8*t + v.vertex.x * .8) * .5 +
                        sin(8*t*2 + v.vertex.x *.8*2) * .5;
						
			v.vertex.y = v.vertex.y + wave;
			v.normal = normalize(float3(v.normal.x + wave, v.normal.y, v.normal.z));
			o.vertColor = wave + 2;
		  
			v.vertex.xyz += v.normal * _Outline;
			
		}
		
        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
		
			half rim = 1- saturate(dot(normalize(IN.viewDir), o.Normal));
			half poweredValue = pow(rim, _RimSlider);
		
			o.Emission = rim< 2 ? (_myEmission*poweredValue)*_OutlineColor.rgb  : 1;
					
			o.Alpha = c.rgb*pow(rim, _AlphaSlider);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
