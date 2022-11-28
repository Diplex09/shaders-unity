Shader "Custom/Border"
{
    Properties
    {
        _Width("Object's width", float) = 0.03
    }

    SubShader
    {
        Pass {
            // Con Stencil definimos las operaciones para determinar qué y cuándo se va a dibujar
            Stencil {
                Ref 1
                Comp Always
                Pass Replace
            }

            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                float4 vert(float4 pos : POSITION) : SV_POSITION{
                    return UnityObjectToClipPos(pos);
                }

                float4 frag() : COLOR {
                    return float4(0.0, 0.0, 1.0, 1.0);
                }
            ENDCG
        }

        Pass {
            Stencil {
                Ref 1
                Comp NotEqual
                Pass Keep
            }

            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                uniform float _Width;

                float4 vert(float4 pos : POSITION, float3 normal : NORMAL) : SV_POSITION{
                    return UnityObjectToClipPos(pos + normal * _Width);
                }

                float4 frag() : COLOR {
                    return float4(0.0, 0.0, 0.0, 1.0);
                }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
