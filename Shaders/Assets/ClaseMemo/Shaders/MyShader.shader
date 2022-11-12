Shader "Custom/MyShader"
{
    Properties // Parámetros recibidos desde Unity
    {
        _mainTex ("Texture", 2D) = "white" {}
        _color ("Color", Color) = (1,1,1,1)
    }
    SubShader // En Unity un shader contiene varios posibles subshaders, cada uno con sus propiedades, Unity decide cuál usar
    {
        Pass // Se pueden hacer varios pases en un subshader, cada uno con sus propiedades
        {
            // Aquí van las propiedades del shader embebidas en algún lenguaje de shading
            // En Unity no importa con qué lo escribiste, Unity recompila para la plataforma objetivo
            CGPROGRAM

            // 1. Se define el nombre del shader
            #pragma vertex vert
            #pragma fragment frag

            // Igual que en GLSL usamos uniforms
            uniform float4 _color;
            uniform float _valor;

            // Declarar las funciones para ambos shaders
            // 1 cosa distinta de sintaxis
            // 2 "tipos" de variables / función
            // 1 es el tipo regular
            // Otro es el semantic
            float4 vert (float4 vertexPos : POSITION) : SV_POSITION
            {
                // AQUÍ HAY QUE RECORDAR LA MATRIZ MVP
                // M - Model 
                // V - View 
                // P - Projection 
                // Unity ya tiene un método de conveniencia
                // UnityObjectToClipPos - qué hace?
                // float4 desplazado = float4(vertexPos.x + _ValorChido, vertexPos.y, vertexPos.z, vertexPos.w);

                // animar a la figura como un pez nadando
                float4 resultado = UnityObjectToClipPos(vertexPos);
                return float4(resultado.x + cos(_Time.g), resultado.y, resultado.z, resultado.w);
                
            }

            float4 frag() : COLOR
            {
                // rgba - el a puede ser ignorado (depende de cómo se esté utilizando el shader)
                // Los valores van de 0 a 1
                return _color;
            }

            ENDCG
        }
    }
}
