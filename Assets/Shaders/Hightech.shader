Shader "Custom/Hightech"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _GlowColor ("Glow Color", Color) = (0, 1, 1, 1)
        _GlowIntensity ("Glow Intensity", Range(0, 5)) = 1
        _MainTex ("Texture", 2D) = "white" {}
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass
        {
            // Vertex Shader
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 pos : TEXCOORD1;
            };

            sampler2D _MainTex;
            fixed4 _Color;
            fixed4 _GlowColor;
            float _GlowIntensity;

            v2f vert (appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.pos = v.vertex;
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 glow = _GlowColor.rgb * _GlowIntensity * sin(_Time.y * 3.0 + i.pos.x + i.pos.y);
                fixed4 texColor = tex2D(_MainTex, i.uv) * _Color;

                // Combine base texture color with glow
                return texColor + fixed4(glow, 0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
