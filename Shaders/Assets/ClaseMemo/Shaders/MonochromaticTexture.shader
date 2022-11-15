Shader "Custom/MonochromaticTexture"
{
    Properties // Parámetros recibidos desde Unity
    {
        _environmentalMaterial ("Environmental Color", Color) = (1, 1, 1, 1)
        _diffuseMaterial ("Diffuse Color", Color) = (1, 1, 1, 1)
        _environmentalAttenuation ("Environmental Attenuation", float) = 0.2
        _specularMaterial ("Specular Color", Color) = (1, 1, 1, 1)
        _brightness("Brightness Coficient", float) = 100
        _texture("Object Texture", 2D) = "white" {}
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
            #include "UnityCG.cginc"

            // Igual que en GLSL usamos uniforms
            uniform float4 _environmentalMaterial;
            uniform float4 _diffuseMaterial;
            uniform float4 _LightColor0;
            uniform float _environmentalAttenuation;
            uniform float4 _specularMaterial;
            uniform float _brightness;
            uniform sampler2D _texture;

            // NUEVO - definicón de la estructura para manejo de datos de retorno / parámetros
            struct vInput {
                float4 vertexPos : POSITION;
                float3 normal : NORMAL;
                float4 coord : TEXCOORD0;
            };

            struct vOutput {
                float4 vertexLocal : TEXCOORD1;
                float4 vertexPos : SV_POSITION;
                float3 normal : NORMAL;
                float4 coord : TEXCOORD0;
            };

            // Declarar las funciones para ambos shaders
            // 1 cosa distinta de sintaxis
            // 2 "tipos" de variables / función
            // 1 es el tipo regular
            // Otro es el semantic
            vOutput vert(vInput input)
            {
                vOutput result;
                result.vertexPos = UnityObjectToClipPos(input.vertexPos);
                result.normal = UnityObjectToWorldNormal(input.normal);
                result.vertexLocal = input.vertexPos;
                result.coord = input.coord;
                return result;
            }

            float4 frag(vOutput input) : COLOR
            {
                // ambiental
                // kaia = material * luz (opcional: * atenuación ambiental)
                float4 environmental = _environmentalMaterial * _LightColor0 * _environmentalAttenuation;


                // difuso
                // kd(l . n)id = material difuso(vector que apunta hacia la luz . )luz
                float4 kd = _diffuseMaterial * _LightColor0 * max(0, dot(input.normal, _WorldSpaceLightPos0.xyz));
                float4 id = _LightColor0;

                // NOTA IMPORTANTE
                // LAS OPERACIONES DEBEN SER REALIZADAS EN EL MISMO ESPACIO (LOCAL, GLOBAL, ETC)
                // l = vector que apunta hacia la luz (en el espacio del mundo)
                float3 l = normalize(_WorldSpaceLightPos0.xyz - input.vertexPos.xyz);

                // n = vector normal (la normal de todos los vértices está en el espacio local)
                float3 n = UnityObjectToWorldNormal(input.normal);

                // Prodcuto punto A . B = |A| * |B| * cos(ángulo entre A y B)
                float4 diffuse = kd * max(0, dot(l, n)) * id;


                // especular
                // ks (r . v)^n = material especular (vector reflejado . vector hacia la cámara)^brillo
                // En espacio global
                float3 r = reflect(-l, n);
                // Vamos a sacar V (el vector que apunta hacia la cámara)
                // La posición ya la tenemos PERO en coordenadas homogéneas
                float3 vGlobal = mul(unity_ObjectToWorld, input.vertexLocal).xyz;
                // La posición de la cámara está en el espacio global y ya la tenemos en WorldSpaceCameraPos
                float3 v = normalize(_WorldSpaceCameraPos - vGlobal);
                float4 ks = _specularMaterial;
                float4 is = _LightColor0;
                float a = _brightness;
                float4 specular = ks * is * pow(max(dot(r, v), 0), a);


                float4 phong = (environmental + diffuse + specular) * tex2D(_texture, input.coord.xy);


                // Transformar to monochromatic
                float red = phong.r;
                float green = phong.g;
                float blue = phong.b;

                float newColor = (red + green + blue) / 3;

                float4 monochromatic = float4(newColor, newColor, newColor, phong.a);

                return monochromatic;
            }

            ENDCG
        }
    }
}
