Shader "Custom/SphereShader" {
	Properties {
	    _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _Boost ("Boost", Float) = 1
        _Reduce ("Reduce", Float) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

        Pass{

		CGPROGRAM
	    #pragma vertex vert
        #pragma fragment frag
        #pragma glsl
        #pragma target 3.0
        #include "UnityCG.cginc"

       sampler2D _MainTex;
       float4 _Color;
       float _Boost;
       float _Reduce;

        struct v2f{
            float4 vertex   : SV_POSITION;
            fixed4 color    : COLOR;
            half2 texcoord  : TEXCOORD0;
            float offset    : Float;
        };

        v2f vert(appdata_full IN){
            v2f OUT;

            float4 colors = tex2Dlod(_MainTex, IN.texcoord);
            float rgbSum = colors.r + colors.g + colors.b;
            float offset = rgbSum / 3.0;

            offset = rgbSum + sin(_Time.z + offset * 10);

            float4 vertex = IN.vertex;
            vertex.xyz = vertex.xyz + IN.normal * offset * _Boost * _Reduce;
            OUT.vertex = mul(UNITY_MATRIX_MVP, vertex);

            OUT.texcoord = IN.texcoord;
            OUT.offset = offset;

            return OUT;
        }

        fixed4 frag(v2f IN) : SV_Target {
                return _Color * IN.offset *0.3;
        }

		ENDCG
        }
	}
	FallBack "Diffuse"
}
