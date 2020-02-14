Shader "Unlit/ReptationAndRandom"
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

			float hash(float2 uv){
				return frac(43758.5453123 * sin(dot(uv,float2(12.9898,78.233))));
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv - 0.5;
				
				float2 p = uv;

				p *= 8.0;

				float2 iuv = floor(p);
				float2 fuv = frac(p) - 0.5;
				float h = hash(iuv);

				float d0 = h < 0.5 ? sdCircle(fuv,0.25) : 1.0;
 				fixed4 col = smoothstep(0.001,0.0,d0);
				return col;
			}
			ENDCG
		}
	}
}
