Shader "Unlit/Animation"
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
				
				float2 p = uv - float2(-0.25,0.25);
				float time = fmod(_Time.y,20.0);
				float t0 = clamp(time,0.0,5.0);
				float t1 = clamp(time - 5.0,0.0,3.0);
				float t2 = clamp(time - 8.0,0.0,7.0);
				float t3 = clamp(time - 15.0,0.0,5.0);

				p -= float2(0.5,0.0) * t0/5.0 + float2(0.0,-0.5) * t1/3.0 + float2(-0.5,0.0) * t2/7.0 + float2(0.0,0.5) * t3/5.0;

				float d0 = sdBox(p,0.125);
 				fixed4 col = smoothstep(0.001,0.0,d0);
				return col;
			}
			ENDCG
		}
	}
}
