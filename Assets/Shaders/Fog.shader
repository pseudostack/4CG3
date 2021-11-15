// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

#warning Upgrade NOTE: unity_Scale shader variable was removed; replaced 'unity_Scale.w' with '1.0'
// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Fog"
{
    Properties
    {

        [Header(Textures and color)]
        [Space]
        _MainTex ("Fog texture", 2D) = "white" {}
        [NoScaleOffset] _Mask ("Mask", 2D) = "white" {}
        _Color ("Color", color) = (1., 1., 1., 1.)
        [Space(10)]
 
        [Header(Behaviour)]
        [Space]
        _ScrollDirX ("Scroll along X", Range(-1., 10.)) = 1.
        _ScrollDirY ("Scroll along Y", Range(-1., 10.)) = 1.
        _Speed ("Speed", float) = 1.
        _Distance ("Fading distance", Range(-5, 10.)) = 1.
			  _ScaleX ("Scale X", Float) = 1.0
      _ScaleY ("Scale Y", Float) = 1.0
    }
 
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off
        Cull Off
 
        Pass
        {
			Cull Back
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           
            #include "UnityCG.cginc"
			
            struct v2f 
			{
                float4 pos : SV_POSITION;
                fixed4 vertCol : COLOR0;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
            
			};
 
            sampler2D _MainTex;
            float4 _MainTex_ST;
			
	       uniform float _ScaleX;
			uniform float _ScaleY;
 
            v2f vert(appdata_full v)
            {
                v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv2 = v.texcoord;
                o.vertCol = v.color;

                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);		
          
				o.pos = mul(UNITY_MATRIX_P, mul(UNITY_MATRIX_MV, float4(0.0, 0.0, 0.0, 1.0))
						+ float4(v.vertex.x, v.vertex.y, 0.0, 0.0) * float4(_ScaleX, _ScaleY, 1.0, 1.0));
				
                return o;
            }
 
            float _Distance;
            sampler2D _Mask;
            float _Speed;
            fixed _ScrollDirX;
            fixed _ScrollDirY;
            fixed4 _Color;
 
            fixed4 frag(v2f i) : SV_Target
            {
                float2 uv = i.uv + fixed2(_ScrollDirX, _ScrollDirY) * _Speed * _Time.x;
                fixed4 col = tex2D(_MainTex, uv) * _Color * i.vertCol;
                col.a *= tex2D(_Mask, i.uv2).r;
                col.a *= 1 - ((i.pos.z / i.pos.w) * _Distance);
                return col;
            }	
            ENDCG
        }
    }
}

