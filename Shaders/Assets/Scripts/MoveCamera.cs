using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveCamera : MonoBehaviour
{

    [SerializeField] private int _speed = 2;
    [SerializeField] private int _speedLevel = 0;
    [SerializeField] private Vector3[] _positions;
    [SerializeField] private int _positionIndex = 0;
    [SerializeField] private bool _isMoving = false;
    [SerializeField] private bool _isAutomatic = true;
    [SerializeField] private bool _isReturning = false;
    [SerializeField] private Vector3 _currentPosition;

    // Update is called once per frame
    void Update()
    {
        int lastSpeedValue = 4;
        // When movement is not automatic, move when the user presses the arrow keys
        if (!_isAutomatic) {

            if(!_isMoving) {
                if (Input.GetKeyDown(KeyCode.LeftArrow))
                {
                    if (_positionIndex < _positions.Length - 1) {
                        _positionIndex++;
                    } else {
                        _positionIndex = 0;
                        lastSpeedValue = _speed;
                        _speed = 30;
                        _isReturning = true;
                    }

                    _currentPosition = _positions[_positionIndex];
                    transform.position = Vector3.Lerp(transform.position, _currentPosition, Time.deltaTime * _speed);
                    _isMoving = true;
                }

                if (Input.GetKeyDown(KeyCode.RightArrow))
                {
                    if (_positionIndex > 0) {
                        _positionIndex--;
                    } else {
                        _positionIndex = _positions.Length - 1;
                        lastSpeedValue = _speed;
                        _speed = 30;
                        _isReturning = true;
                    }

                    _currentPosition = _positions[_positionIndex];
                    transform.position = Vector3.Lerp(transform.position, _currentPosition, Time.deltaTime * _speed);
                    _isMoving = true;
                }
            }
            
            if (transform.position == _currentPosition) {
                _isMoving = false;
                if (_isReturning) {
                    _speed = lastSpeedValue;
                    _isReturning = false;
                }
            } else {
                transform.position = Vector3.MoveTowards(transform.position, _currentPosition, _speed * Time.deltaTime);
            }

        } else {
            if (!_isMoving) {
                _currentPosition = _positions[_positionIndex];
                transform.position = Vector3.MoveTowards(transform.position, _currentPosition, _speed * Time.deltaTime);
                _isMoving = true;
            } else {
                // Check if the camera has reached the next position
                if (transform.position == _currentPosition) {
                    _isMoving = false;
                    // Move the camera to the next position
                    if (_positionIndex < _positions.Length - 1)
                    {
                        _positionIndex++;
                    }
                    else
                    {
                        _positionIndex = 0;
                    }
                } else {
                    transform.position = Vector3.MoveTowards(transform.position, _currentPosition, _speed * Time.deltaTime);
                }
            }
        }

        // Automatic movement when a key is pressed
        if (Input.GetKeyDown(KeyCode.A))
        {
            _isAutomatic = !_isAutomatic;
        }

        // Change camera movement speed
        if (Input.GetKeyDown(KeyCode.V))
        {
            _speedLevel++;
            if (_speedLevel > 2)
            {
                _speedLevel = 0;
            }
            switch (_speedLevel)
            {
                case 0:
                    _speed = 2;
                    break;
                case 1:
                    _speed = 4;
                    break;
                case 2:
                    _speed = 6;
                    break;
            }
        }
    }
}
