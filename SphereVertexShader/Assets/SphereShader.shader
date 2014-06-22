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
            float offset = (colors.r + colors.g + colors.b) / 3.0;
            
            float offset2 = (colors.r + colors.g + colors.b) + sin(_Time.z + offset * 10) * _Boost;
            offset2 = offset2 / _Reduce;
            
            float4 vertex = IN.vertex;
            vertex.xyz = vertex.xyz + IN.normal * offset2;
            OUT.vertex = mul(UNITY_MATRIX_MVP, vertex);
            OUT.vertex.xyz = OUT.vertex.xyz;
            
            OUT.texcoord = IN.texcoord;
            OUT.offset = offset;
            
            return OUT;
        }

        fixed4 frag(v2f IN) : SV_Target {
            
            if (_Color.a == 0){
                if (IN.offset < .2){
                    return fixed4(0,0,0,1);
                }
                return _Color * IN.offset;
            }
            else{
                return tex2D(_MainTex, IN.texcoord);
            }
        }
		
		ENDCG
        }
	} 
	FallBack "Diffuse"
}
