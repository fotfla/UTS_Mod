Shader "Unlit/Union"
{
	Properties
	{
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
			
			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv - 0.5;
				
				float2 p = uv;
				
				float d1 = sdCircle(p - float2(0.125,0.0),0.25);
				float d2 = sdCircle(p - float2(-0.125,0.0),0.25);
				float d0 = min(d1,d2);
 				fixed4 col = smoothstep(0.001,0.0,d0);
				return col;
			}
			ENDCG
		}
	}
}
