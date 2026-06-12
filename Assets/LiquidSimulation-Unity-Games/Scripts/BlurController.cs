
using UnityEngine;

[ExecuteInEditMode]
public class BlurController : MonoBehaviour
{
    [Header("Blur Settings")]
    public int iterations = 3;
    public float blurSpread = 0.6f;

    public Shader blurShader;

    private Material m_Material;

    Material BlurMaterial
    {
        get
        {
            if (m_Material == null)
            {
                m_Material = new Material(blurShader);
                m_Material.hideFlags = HideFlags.DontSave;
            }
            return m_Material;
        }
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (blurShader == null)
        {
            Graphics.Blit(source, destination);
            return;
        }

        int rtW = source.width / 4;
        int rtH = source.height / 4;

        RenderTexture buffer0 = RenderTexture.GetTemporary(rtW, rtH, 0);
        Graphics.Blit(source, buffer0);

        for (int i = 0; i < iterations; i++)
        {
            RenderTexture buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);

            float off = 0.5f + i * blurSpread;

            BlurMaterial.SetVector(
                "_BlurOffsets",
                new Vector4(off, off, 0, 0)
            );

            Graphics.Blit(buffer0, buffer1, BlurMaterial);

            RenderTexture.ReleaseTemporary(buffer0);
            buffer0 = buffer1;
        }

        Graphics.Blit(buffer0, destination);

        RenderTexture.ReleaseTemporary(buffer0);
    }

    void OnDestroy()
    {
        if (m_Material != null)
        {
            DestroyImmediate(m_Material);
        }
    }
}