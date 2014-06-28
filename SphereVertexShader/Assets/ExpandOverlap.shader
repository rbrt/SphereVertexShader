
Shader "Custom/ExpandOverlap"
{
	Properties
	{
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB)", 2D) = "white" {}
    _TexWidth ("Texture Width", Int) = 0
    _TexHeight ("Texture Height", Int) = 0
	}

	SubShader
	{
		Pass
		{
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
			};

			fixed4 _Color;
			fixed4 _BaseColor;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				float4 hey = IN.vertex;
				OUT.vertex = mul(UNITY_MATRIX_MVP, hey);
				OUT.texcoord = IN.texcoord;

				OUT.color = IN.color * _Color;

				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap (OUT.vertex);
				#endif

				return OUT;
			}

			sampler2D _MainTex;
            int _TexWidth;
            int _TexHeight;
			fixed4 frag(v2f IN) : COLOR
			{
					fixed2 newPoint;
                    // Convert to unit circle dealie
					float centerCoordx = (IN.texcoord.x * 2 - 1);
					float centerCoordy = (IN.texcoord.y * 2 - 1);

                    float k = _Time.x;

                    float aX = centerCoordx;
                    float aY = centerCoordy;

                    // Handle coords based on quadrents
                    // Left Side
                    if (centerCoordx < 0){
                        aX = centerCoordx + (1 - k);

                        // If we pass the middle
                        if (aX > 0){
                            aX = -1 + aX;
                        }
                    }
                    else{
                        aX = centerCoordx - (1 - k);
                        if (aX < 0){
                            aX = 1 - aX;
                        }
                    }

                    if (centerCoordy < 0){
                        aY = centerCoordy + (1 - k);
                        if (aY > 0){
                            aY = -1 + aY;
                        }
                    }
                    else{
                        aY = centerCoordy - (1 - k);
                        if (aY < 0){
                            aY = -1 - aY;
                        }
                    }

					newPoint = fixed2((aX + 1) / 2, (aY + 1) / 2);


				  return tex2D(_MainTex, newPoint);

			}
		ENDCG
		}
	}
}
