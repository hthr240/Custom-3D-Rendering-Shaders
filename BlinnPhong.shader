Shader "CG/BlinnPhong"
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
                    float3 normal : TEXCOORD0;    
                    float3 worldPos : TEXCOORD1;  
                };

                fixed4 pointLights(v2f input)
                {
                    float3 worldPos = input.worldPos;
                    float3 normal = normalize(input.normal);
                    
                    fixed3 Diffuse = fixed3(0, 0, 0);
                    
                    float4 lightPositionX = unity_4LightPosX0;
                    float4 lightPositionY = unity_4LightPosY0;
                    float4 lightPositionZ = unity_4LightPosZ0;
                    
                    float4 lightAttenSq = unity_4LightAtten0; 

                    //going throguh each each light with each coordinates
                    for (int i = 0; i < 4; i++)
                    {
                        float3 lightPosition = float3(lightPositionX[i], lightPositionY[i], lightPositionZ[i]);
                        
                        float distance = dot(lightPosition - worldPos, lightPosition - worldPos);
                        
                        //calculation from TA 
                        float atten = 1.0 / (1.0 + distance * lightAttenSq[i]);

                        float3 L = normalize(lightPosition - worldPos);
                    
                        Diffuse += unity_LightColor[i].rgb * max(0.0, dot(normal, L)) * atten;
                    }

                    return fixed4(Diffuse, 0);
                }


                v2f vert (appdata input)
                {
                    v2f output;
                    
                    //regular calculation for the lights to the world object
                    output.pos = UnityObjectToClipPos(input.vertex);

                    output.normal = normalize(mul(input.normal, (float3x3)unity_WorldToObject));;

                    output.worldPos = mul(unity_ObjectToWorld, input.vertex).xyz;

                    return output;
                }


                fixed4 frag (v2f input) : SV_Target
                {
                    float3 lightDiraction = normalize(_WorldSpaceLightPos0.xyz);
                    float3 normal = normalize(input.normal);
                    float3 viewDiraction = normalize(_WorldSpaceCameraPos - input.worldPos);

                    
                    fixed3 ambient = _AmbientColor.rgb * _LightColor0.rgb;

                    //Calculation for diffuse 
                    fixed3 diffuse = _DiffuseColor.rgb * _LightColor0.rgb * max(0.0, dot(normal, lightDiraction));;

                    // Calculation for Specular 
                    float3 halfVector = normalize(lightDiraction + viewDiraction);
                    fixed3 specular = _SpecularColor.rgb * _LightColor0.rgb * pow(max(0.0, dot(normal, halfVector)), _Shininess);

                    //Points Lights
                    fixed4 additionalLights = pointLights(input);

                    //Calculation for final color with point lights
                    fixed3 finalRGB = ambient + diffuse + specular + (additionalLights.rgb * _DiffuseColor.rgb);

                    // fixing the return type.
                    return fixed4(finalRGB, 1.0);

                }

            ENDCG
        }
    }
}
