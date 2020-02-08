Shader "Unlit/PlayingCards"
{
	Properties
	{
		[KeywordEnum(Heart,Dia,Spade,Club,Ace)]
		_Figure("Figure",int) = 0
		[Toggle(_MIRROR_ON)]
		_Mirror("Mirror",int) = 0
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
			#pragma multi_compile _FIGURE_HEART _FIGURE_DIA _FIGURE_SPADE _FIGURE_CLUB _FIGURE_ACE
			#pragma shader_feature _ _MIRROR_ON
			
			#include "UnityCG.cginc"
			#include "../sdf.cginc"

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
               return frac(41531.16361 * sin(dot(uv,float2(12.613,78.5316))));
            }

            float2x2 rot(float a){
               float c = cos(a), s = sin(a);
               return float2x2(c,s,-s,c);
            }

			float sdHeart(float2 p,float s){
               p /=s;
			   
			   #ifdef _MIRROR_ON
               p.x = abs(p.x);
			   #endif

               float d = sdLine(p,float2(-0.125,-0.125),float2(0.25,0.25),0.25);
                return d;
            }

            float sdSpade(float2 p,float s){
               p /= s;
               p.y = - p.y + 0.25;
               float h = sdHeart(p,1.0);
               float d = sdTriangleIsoscales(p - float2(0.0,0.3),float2(0.1,0.5));
               h = min(h,d);
               return h;
            }

            float sdDia(float2 p, float s){
               p.x /= 0.7;
               p = mul(rot(UNITY_PI * 0.25),p);
               float d = sdBox(p,s*0.4);
               return d;
            }

            float sdClub(float2 p,float s){
               p /= s* 1.5;

			   #ifdef _MIRROR_ON
			   p.x = abs(p.x);
			   #endif

               float d0 = sdCircle(p - float2(0.0,0.2),0.2);
               float d1 = sdCircle(p - float2(0.15,0.0),0.2);
               d0 = min(d0,d1);

               p.y = - p.y;
               float d = sdTriangleIsoscales(p - float2(0.0,0.1),float2(0.05,0.25));
               d0 =min(d0,d);
               return d0;
            }

			float sdAce(float2 p,float s){
				p /= s * 2.0;
				
				#ifdef _MIRROR_ON
				p.x = abs(p.x);
				#endif

				float d = sdLine(p,float2(-0.05,0.3),float2(0.125,-0.25),0.025);
				float d1 = sdLine(p,float2(0.0,-0.1),float2(0.075,-0.1),0.0125);
				float b0 = sdBox(p - float2(0.125,-0.25),float2(0.05,0.0125));
				d = min(d,min(d1,b0));
				float b = sdBox(p - float2(0.0,-0.375),float2(0.25,0.125));
				d = max(d,-b);
                return d;
            }
			
			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv - 0.5;
				float2 p = uv;
				
				#ifdef _FIGURE_HEART
				float d0 = sdHeart(uv,0.5);
				#elif _FIGURE_DIA
				float d0 = sdDia(uv,0.5);
				#elif _FIGURE_SPADE
				float d0 =sdSpade(uv,0.5);
				#elif _FIGURE_CLUB
				float d0 = sdClub(uv,0.5);
				#elif _FIGURE_ACE
				float d0 = sdAce(uv,0.5);
				#endif
				
 				fixed4 col = smoothstep(0.001,0.0,d0);
				return col;
			}
			ENDCG
		}
	}
}
