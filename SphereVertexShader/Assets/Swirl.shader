
Shader "Custom/Swirl"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
	}

	SubShader
	{
		Tags
		{
			"Queue"="Transparent"
			"IgnoreProjector"="True"
			"RenderType"="Transparent"
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}

		Cull Off
		Lighting Off
		ZWrite Off
		Fog { Mode Off }
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile DUMMY PIXELSNAP_ON
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

			fixed4 frag(v2f IN) : COLOR
			{

					// Rotate that stuff
					fixed2 newPoint;

					float theta = _Time.x * 1.5;

					float centerCoordx = (IN.texcoord.x * 2 - 1);
					float centerCoordy = (IN.texcoord.y * 2 - 1);

					// will be between 0 and 1
					float len = sqrt(pow(centerCoordx, 2) + pow(centerCoordy, 2));


					float2 vecA = float2(centerCoordx, centerCoordy);
					float2 vecB = float2(len, 0);

					float initialValue = dot(vecA, vecB) / (len * 1);
					float degree = degrees(acos(initialValue));

					float thetamod = degree / 18 * sin(len * 100 / 2);
					theta += thetamod * (_Time.x /10) ;

					newPoint = fixed2((cos(theta) * (IN.texcoord.x * 2 - 1) + sin(theta) * (IN.texcoord.y * 2 - 1) + 1)/2,
			  				    	  (-sin(theta) * (IN.texcoord.x * 2 - 1) + cos(theta) * (IN.texcoord.y * 2 - 1) + 1)/2);


				  	return tex2D(_MainTex, newPoint) ;
			}
		ENDCG
		}
	}
}
