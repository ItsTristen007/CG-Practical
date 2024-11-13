Shader "Custom/Lava Wave"
{  
  Properties
    {
        // Water Shader Properties
        _MainTex("Diffuse", 2D) = "white" {}
        _Tint("Colour Tint", Color) = (1,1,1,1)
        _Freq("Frequency", Range(0,5)) = 3
        _Speed("Speed", Range(0,100)) = 10
        _Amp("Amplitude", Range(0,1)) = 0.5

        // Scrolling Texture Properties
        _ScrollX("Scroll X", Range(-5,5)) = 1
        _ScrollY("Scroll Y", Range(-5,5)) = 1

        // Foam Overlay Properties
        _FoamTex("Foam", 2D) = "white" {}
    }

    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert vertex:vert

        // Water shader properties
        float4 _Tint;
        float _Freq;
        float _Speed;
        float _Amp;

        // Scrolling texture properties
        float _ScrollX;
        float _ScrollY;

        // Foam texture
        sampler2D _MainTex;
        sampler2D _FoamTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 vertColor;
        };

        // Vertex shader
        struct appdata
        {
            float4 vertex : POSITION;
            float3 normal : NORMAL;
            float4 texcoord : TEXCOORD0;
            float4 texcoord1 : TEXCOORD1;
            float4 texcoord2 : TEXCOORD2;
        };

        void vert(inout appdata v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            float t = _Time * _Speed;
            // Wave height calculation
            float waveHeight = sin(t + v.vertex.x * _Freq) * _Amp + sin(t*2 + v.vertex.x * _Freq*2) * _Amp;
            v.vertex.y = v.vertex.y + waveHeight;
            v.normal = normalize(float3(v.normal.x + waveHeight, v.normal.y, v.normal.z));
            o.vertColor = waveHeight + 2;
        }

        // Fragment shader (Surface Shader)
        void surf(Input IN, inout SurfaceOutput o)
        {
            // Scrolling water texture
            _ScrollX += _Time * 0.1; // Adjust scroll speed if needed
            _ScrollY += _Time * 0.1;
            float2 newUV = IN.uv_MainTex + float2(_ScrollX, _ScrollY);

            // Get the water color (main texture)
            float4 c = tex2D(_MainTex, newUV);
            o.Albedo = c.rgb * IN.vertColor.rgb;

            // Add foam overlay
            float2 foamUV = IN.uv_MainTex + float2(_ScrollX, _ScrollY); // Foam scrolls slower
            float3 foam = tex2D(_FoamTex, foamUV).rgb;

            // Combine water texture and foam overlay
            o.Albedo = lerp(o.Albedo, foam, 0.5); // You can adjust the lerp factor for more/less foam blending
        }

        ENDCG
    }
    FallBack "Diffuse"
}