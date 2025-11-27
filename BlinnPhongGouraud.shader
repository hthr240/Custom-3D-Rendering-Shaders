Shader "CG/BlinnPhongGouraud"
{
    Properties
    {
        _DiffuseColor ("Diffuse Color", Color) = (0.14, 0.43, 0.84, 1)
        _SpecularColor ("Specular Color", Color) = (0.7, 0.7, 0.7, 1)
        _AmbientColor ("Ambient Color", Color) = (0.05, 0.13, 0.25, 1)
        _Shininess ("Shininess", Range(0.1, 50)) = 10
    }
    SubShader
    {
        Pass
        {
            Tags { "LightMode" = "ForwardBase" } 

            CGPROGRAM

                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"
                #include "Lighting.cginc"

                // Declare used properties
                uniform fixed4 _DiffuseColor;
                uniform fixed4 _SpecularColor;
                uniform fixed4 _AmbientColor;
                uniform float _Shininess;

                struct appdata
                { 
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                };

                struct v2f
                {
                    float4 pos : SV_POSITION;
                    fixed4 color : COLOR0;
                };


                v2f vert (appdata input)
                {
                    v2f output;
                    output.pos = UnityObjectToClipPos(input.vertex);

                    float3 worldPos = mul(unity_ObjectToWorld, input.vertex).xyz;

                    float3 worldNormal = normalize(mul(input.normal, (float3x3)unity_WorldToObject));

                    float3 v = normalize(_WorldSpaceCameraPos - worldPos);

                    float3 l = normalize(_WorldSpaceLightPos0.xyz);

                    float3 h = normalize(l + v);

                    // calculation from TA3

                    // calculate ambient 
                    fixed4 ambient = _AmbientColor * _LightColor0;
                    // calculate diffuse 
                    fixed4 diffuse = _DiffuseColor * _LightColor0 * max(0, dot(worldNormal, l));
                    // calculate specular term
                    fixed4 specular = _SpecularColor * _LightColor0 * pow(max(0, dot(worldNormal, h)), _Shininess);

                    output.color = ambient + diffuse + specular;
                    return output;
                }


                fixed4 frag (v2f input) : SV_Target
                {
                    return input.color;
                }

            ENDCG
        }
    }
}
