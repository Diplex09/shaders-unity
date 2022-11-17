using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIController : MonoBehaviour
{
    [SerializeField] private GameObject _controlsPanel;
    [SerializeField] private GameObject _noControlsPanel;

    // Update is called once per frame
    void Update()
    {
        // If h is pressed, show the controls panel
        if (Input.GetKeyDown(KeyCode.H))
        {
            _controlsPanel.SetActive(_controlsPanel.activeSelf ? false : true);
            _noControlsPanel.SetActive(_noControlsPanel.activeSelf ? false : true);
        }
    }
}
