Shader "Projector/Selection Indicator" {
    Properties {
        _MainTex ("Cookie", 2D) = "white" {}
		_Color ("Tint", Color) = (1, 1, 1, 1)
		_Alpha ("Alpha", Range (0, 1)) = 1.0
    }
    Subshader {
        Tags {"Queue"="Transparent"}
        Pass {

			Stencil {
				Ref 0
				Comp Equal
			}

            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            //Offset -1, -1
     
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
               
            struct v2f {
                float4 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
            };
               
            float4x4 unity_Projector;
               
            v2f vert (float4 vertex : POSITION)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                o.uv = mul (unity_Projector, vertex);
                return o;
            }
               
            sampler2D _MainTex;
			float4 _Color;
			float _Alpha;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 o = tex2Dproj (_MainTex, UNITY_PROJ_COORD(i.uv));
				o.rgb *= _Color;
				o.a *= _Alpha;
                return o;
            }
            ENDCG
        }
    }
}
