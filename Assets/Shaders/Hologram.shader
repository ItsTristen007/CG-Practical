Shader "Custom/Hologram"
{
    Properties
    {
        _RimColor ("Rim Color", Color) = (0,0.5,0.5,0.0)
        _RimPower("Rim Power", Range(0.1,8.0)) = 3.0
    }
    SubShader
    {
        //Can change this to Geometry for non transparent 
        Tags {"Queue" = "Transparent"}
        
        //can delete this for non transparent 
        Pass
        {
            ZWrite On
            ColorMask 0
        }
        
        CGPROGRAM

        // can remove alpha:fade for non transparent 
        #pragma surface surf Lambert alpha:fade 
        struct Input
        {
            float3 viewDir;
        };

        float4 _RimColor;
        float _RimPower;

        void surf (Input IN, inout SurfaceOutput o)
        {
           half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
            o.Emission = _RimColor.rgb *pow(rim, _RimPower) * 10;
            // can remove this for non transparent 
            o.Alpha = pow(rim, _RimPower);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
