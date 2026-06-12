Shader "VueCode/UnlitMod_Unity6"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Main Color", Color) = (0.3,0.7,1,1)

        _Cutoff("Density Cutoff", Range(0,1)) = 0.25

        _Stroke ("Stroke Size", Range(0,1)) = 0.1
        _StrokeColor ("Stroke Color", Color) = (1,1,1,1)
    }

    SubShader
    {
        Tags
        {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
        }

        LOD 100
        Lighting Off
        Cull Off
        ZWrite Off

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            fixed4 _Color;
            fixed4 _StrokeColor;

            float _Cutoff;
            float _Stroke;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                // Usar intensidad en lugar de alpha
                float density = max(col.r, max(col.g, col.b));

                clip(density - _Cutoff);

                if (density < (_Cutoff + _Stroke))
                    return _StrokeColor;

                return _Color;
            }

            ENDCG
        }
    }

    Fallback Off
}