Shader "Unlit/Scale"
{
	Properties
	{
		
		_Scale("Scale",Range(0.0001,4)) = 2
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "sdf.cginc"

			float _Scale;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			float2x2 rot(float a){
				float c= cos(a),s = sin(a);
				return float2x2(c,s,-s,c);
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv - 0.5;
				
				float2 p = uv;
				
				p /= _Scale;

				float d0 = sdBox(p,0.125);
 				fixed4 col = smoothstep(0.001,0.0,d0);
				return col;
			}
			ENDCG
		}
	}
}
