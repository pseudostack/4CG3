Shader "Custom/AquariumFrameShader"
{
    Properties{

      //properties for diffuse and emission textures, inialized to white
      _DiffuseTex("Diffuse Texture", 2D) = "white" {}
      _EmissionTex("Emission Texture", 2D) = "white" {}

      //properties for sliders for diffuse and emission from 0 to 1
      _DiffuseAmount("Diffuse Amount", Range(0,10)) = 1
      _EmissionAmount("Emission Amount", Range(0,10)) = 1
    }

SubShader{

  CGPROGRAM

  #pragma surface surf Lambert

  struct Input{
    //obtain diffuse and emission texture uv coordinates
    float2 uv_DiffuseTex;
    float2 uv_EmissionTex;
  };

  //textures will be of sampler2D data type
  sampler2D _DiffuseTex;
  sampler2D _EmissionTex;

  //sliders will be half data type to save memory
  half _DiffuseAmount;
  half _EmissionAmount;

  void surf(Input IN, inout SurfaceOutput o){

    //obtain and assign our diffuse texture color values to our albedo output
    //filtered for RGB channels
    o.Albedo = tex2D(_DiffuseTex, IN.uv_DiffuseTex).rgb;

    //multiply by diffuse amount to allow adjustment
    o.Albedo *= _DiffuseAmount;

    //obtain and assign our emission texture color values to the emission output
    //filtered for RGB channels
    o.Emission = tex2D(_EmissionTex, IN.uv_EmissionTex).rgb;

    //multiply by the emission amount to allow adjustments
    o.Emission *= _EmissionAmount;

  }
ENDCG
}
    Fallback "Diffuse"
}
