using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraScript : MonoBehaviour
{
    public Material Lut1;
    public Material Lut2;
    public Material Lut3;
    public Material Lut4;

    private Material[] luts;
    private bool[] lutEnabled;
    private int currentLutIndex = -1; 

    void Start()
    {
        luts = new Material[] { Lut1, Lut2, Lut3, Lut4 };
        lutEnabled = new bool[] { true, true, true, true }; 
    }

    void Update()
    {
        // Toggle LUTs on/off
        if (Input.GetKeyDown(KeyCode.Alpha1)) ToggleLUT(0);
        if (Input.GetKeyDown(KeyCode.Alpha2)) ToggleLUT(1);
        if (Input.GetKeyDown(KeyCode.Alpha3)) ToggleLUT(2);
        if (Input.GetKeyDown(KeyCode.Alpha4)) ToggleLUT(3);

        // Switch LUTs based on the number pressed, if enabled
        if (Input.GetKeyDown(KeyCode.Alpha1) && lutEnabled[0]) SwitchLUT(0);
        if (Input.GetKeyDown(KeyCode.Alpha2) && lutEnabled[1]) SwitchLUT(1);
        if (Input.GetKeyDown(KeyCode.Alpha3) && lutEnabled[2]) SwitchLUT(2);
        if (Input.GetKeyDown(KeyCode.Alpha4) && lutEnabled[3]) SwitchLUT(3);
    }

    private void SwitchLUT(int index)
    {
        if (index >= 0 && index < luts.Length && lutEnabled[index])
        {
            currentLutIndex = index;
        }
    }

    private void ToggleLUT(int index)
    {
        if (index >= 0 && index < lutEnabled.Length)
        {
            lutEnabled[index] = !lutEnabled[index];

            
            if (currentLutIndex == index && !lutEnabled[index])
            {
                currentLutIndex = -1; 
            }
        }
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (currentLutIndex >= 0)
        {
            Graphics.Blit(source, destination, luts[currentLutIndex]);
        }
        else
        {
            Graphics.Blit(source, destination); 
        }
    }
}