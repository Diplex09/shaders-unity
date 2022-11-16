using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour
{
    [SerializeField] private float _speed = 5f;
    [SerializeField] private bool _isRotating = true;
    [SerializeField] private bool _isClockwise = true;
    [SerializeField] private Vector3 _initialRotation;

    void Start()
    {
        // Save the actual rotation vector of the object
        _initialRotation = transform.rotation.eulerAngles;
        Debug.Log("Initial rotation: " + _initialRotation);
        _isRotating = false;
    }

    void Update()
    {
        // Rotate when the user presses the space bar
        if (Input.GetKeyDown(KeyCode.Space))
        {
            _isRotating = !_isRotating;
        }
        // Change the direction of rotation when the user presses the left shift key
        if (Input.GetKeyDown(KeyCode.LeftShift))
        {
            _isClockwise = !_isClockwise;
        }
        // Reset rotation when the user presses the R key
        if (Input.GetKeyDown(KeyCode.R))
        {
            transform.rotation = Quaternion.Euler(_initialRotation);
        }

        // Rotate the object
        if (_isRotating)
        {
            if (_isClockwise)
            {
                transform.Rotate(new Vector3(0, 30f, 0f) * Time.deltaTime * _speed);
            }
            else
            {
                transform.Rotate(new Vector3(0, -30f, 0f) * Time.deltaTime * _speed);
            }
        }        
    }
}
