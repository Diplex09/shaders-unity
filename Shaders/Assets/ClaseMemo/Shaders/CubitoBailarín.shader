Shader "Custom/CubitoBailarín"
{
    Properties // Parámetros recibidos desde Unity
    {
        _color ("Color", Color) = (1,1,1,1)
    }
    SubShader // En Unity un shader contiene varios posibles subshaders, cada uno con sus propiedades, Unity decide cuál usar
    {
        Pass // Se pueden hacer varios pases en un subshader, cada uno con sus propiedades
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            uniform float4 _color;
            uniform float _valor;

            float4 vert (float4 vertexPos : POSITION) : SV_POSITION
            {
                float4 resultado = UnityObjectToClipPos(vertexPos);
                return float4(resultado.x + cos(_Time.g), resultado.y, resultado.z, resultado.w);
                
            }

            float4 frag() : COLOR
            {
                return _color;
            }

            ENDCG
        }
    }
}
