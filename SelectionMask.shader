Shader "Projector/Selection Mask" {
	Properties{
		_MainTex("Cookie", 2D) = "white" {}
	}
		Subshader{
		Tags{ "Queue" = "Transparent-100" }
		Pass{

			Stencil {

				Ref 1
				Comp Always
				Pass Replace

			}

			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
			Offset -1, -1

			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				struct v2f {
					float4 uv : TEXCOORD0;
					float4 pos : SV_POSITION;
				};

				float4x4 unity_Projector;

				v2f vert(float4 vertex : POSITION) {
					v2f o;
					o.pos = UnityObjectToClipPos(vertex);
					o.uv = mul(unity_Projector, vertex);
					return o;
				}

				sampler2D _MainTex;

				fixed4 frag(v2f i) : SV_Target
				{
					fixed4 o = tex2Dproj(_MainTex, UNITY_PROJ_COORD(i.uv));
					if (o.a < 0.3) discard;
					return 0;
					//return fixed4(1.0, 0.0, 1.0, 1.0);
				}
			ENDCG
		}
	}
}
