Shader "Unlit/EMptyVertexShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_ScaleUVX ("Scale X", Range(1,10)) = 1
		_ScaleUVY ("Scale Y", Range(1,10)) =  1
		_ScaleUVZ ("Scale Z", Range(1,10)) =  1

	    _OriginOffset("Offset", Float) = 0.0
		_Skew("Skew", Vector) = (0,0,0,0) // Skews the vertices based upon the difference in the Y coordinate

		_Offset("Offset", Vector) = (0,0,0,0) // The translation of the objects vertices
		_Rotation("Rotation", Vector) = (0,0,0,0) // Rotates the Offset and Skewed mesh by the given X, Y and Z angles
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
				float4 col:COLOR;
            };

			float _ScaleUVX;
			float _ScaleUVY;
						float _ScaleUVZ;
					float _OriginOffset;
			float4 _Offset;
			float4 _Skew;

            sampler2D _MainTex;
            float4 _MainTex_ST;
			
						float4 _Rotation;

			//rotation matrixes
				float3 rotationX(float3 vertex, float rotation) {
				float4 vert = float4(vertex, 1);
				float4x4 mat;
				mat[0] = float4(1, 0, 0, 0);
				mat[1] = float4(0, cos(rotation), -sin(rotation), 0);
				mat[2] = float4(0, sin(rotation), cos(rotation), 0);
				mat[3] = float4(0, 0, 0, 1);
				return mul(mat, vert).xyz;
			}

			float3 rotationY(float3 vertex, float rotation) {
				float4 vert = float4(vertex, 1);
				float4x4 mat;
				mat[0] = float4(cos(rotation), 0, sin(rotation), 0);
				mat[1] = float4(0, 1, 0, 0);
				mat[2] = float4(-sin(rotation), 0, cos(rotation), 0);
				mat[3] = float4(0, 0, 0, 1);
				return mul(mat, vert).xyz;
			}

			float3 rotationZ(float3 vertex, float rotation) {
				float4 vert = float4(vertex, 1);
				float4x4 mat;
				mat[0] = float4(cos(rotation), -sin(rotation), 0, 0);
				mat[1] = float4(sin(rotation), cos(rotation), 0, 0);
				mat[2] = float4(0, 0, 1, 0);
				mat[3] = float4(0, 0, 0, 1);
				return mul(mat, vert).xyz;
			}
			



            v2f vert (appdata v)
            {
                v2f o;
				
				//modify the original positions (using sine wave)
				// v.vertex.x = sin(v.vertex.x * _ScaleUVX);
				//v.vertex.y = sin(v.vertex.y * _ScaleUVY);
				
				//mody not using using sine wave
				//v.vertex.x = v.vertex.x * _ScaleUVX;
				//v.vertex.y = v.vertex.y * _ScaleUVY;
				//v.vertex.z = v.vertex.z * _ScaleUVZ;


				float modifier = v.vertex.y - _OriginOffset;
							
				//for offsetting the object
				v.vertex.xyz += _Offset;
				
				//skew				
				v.vertex.xyz += _Skew.xyz * modifier;
				
				//rotation
				v.vertex.xyz = rotationX(v.vertex.xyz, _Rotation.x * modifier);
				v.vertex.xyz = rotationY(v.vertex.xyz, _Rotation.y * modifier);
				v.vertex.xyz = rotationZ(v.vertex.xyz, _Rotation.z * modifier);
				
				
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				
				//for accessing color
				//o.col.r = o.uv.x;
				//o.col.g = o.uv.y;
				
				//for distortions  (usually used for glass effect)
				// o.uv.x = sin(o.uv.x * _ScaleUVX);
				//o.uv.y = sin(o.uv.y * _ScaleUVY);

				
                 return o;   //returned o to frag as i as input
            }

            fixed4 frag (v2f i) : SV_Target
            {
				//sample the texture here
			
               fixed4 col = tex2D(_MainTex, i.uv);
                
				//used for the o.col.r lines
				//fixed4 col = i.col;
				
				return col;
            }
            ENDCG
        }
    }
}
