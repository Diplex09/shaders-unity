using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour
{
    [SerializeField] private int _speed = 5;
    [SerializeField] private int _speedLevel = 1;
    [SerializeField] private bool _isRotating = true;
    [SerializeField] private bool _isClockwise = true;
    [SerializeField] private Vector3 _initialRotation;

    void Start()
    {
        // Save the actual rotation vector of the object
        _initialRotation = transform.rotation.eulerAngles;
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
        // Change rotation speed
        if (Input.GetKeyDown(KeyCode.S))
        {
            _speedLevel++;
            if (_speedLevel > 2)
            {
                _speedLevel = 0;
            }
            switch (_speedLevel)
            {
                case 0:
                    _speed = 3;
                    break;
                case 1:
                    _speed = 5;
                    break;
                case 2:
                    _speed = 7;
                    break;
            }
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
