Shader "Unlit/sdCircle"
{
	Properties
	{
		[KeywordEnum(Circle,Box,Line)]
		_Figure("Figure",int) = 0
		[KeywordEnum(Normal,Debug)]
		_Mode("Debug Mode",int) = 0
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

			#pragma multi_compile _FIGURE_CIRCLE _FIGURE_BOX _FIGURE_LINE
			#pragma multi_compile _MODE_NORMAL _MODE_DEBUG
			
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
			};
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			float sdCircle(float2 p, float r){
				return length(p) - r;
			}

			float sdBox(float2 p, float2 s){
				float2 d = abs(p) - s;
				return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
			}

			float sdLine(float2 p, float2 a, float2 b, float w){
				float2 pa = p - a;
				float2 ba = b - a;
				float h = saturate(dot(pa,ba)/dot(ba,ba));
				return length(pa - ba * h) - w;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv - 0.5;
				fixed4 col = fixed4(0,0,0,1);

				float d0 = 1.0;
				#ifdef _FIGURE_CIRCLE
				d0 = sdCircle(uv,0.25);
				#elif _FIGURE_BOX
				d0 = sdBox(uv,0.25);
				#elif _FIGURE_LINE
				d0 = sdLine(uv,float2(-0.25,0.0),float2(0.25,0.0),0.0125);
				#endif
				
				#ifdef _MODE_NORMAL
 				col.rgb = smoothstep(0.001,0.0,d0);
				#elif _MODE_DEBUG
				col.rgb = frac(d0 * 10.0) > 0.95 ? 0.0 : 1.0;
				col.rgb *= d0 > 0.0 ? float3(0.0,0.5,1.0) : float3(1.0,0.5,0.0);
				#endif
				return col;
			}
			ENDCG
		}
	}
}
