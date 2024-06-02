using System;
using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography.X509Certificates;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.UIElements;

public class UIController : MonoBehaviour
{

    private VisualElement _lowerCanvas;

    private Button _menuUpButton;

    private Button _menuDownButton;

    private Button _button1;
    private Button _button2;
    private Button _button3;
    private Button _button4;


    // Start is called before the first frame update
    void Start()
    {
        var root = GetComponent<UIDocument>().rootVisualElement;
        _lowerCanvas = root.Q<VisualElement>("LowerCanvas");
        _menuUpButton = root.Q<Button>("menuUpButton");
        _menuDownButton = root.Q<Button>("menuDownButton");
        _button1 = root.Q<Button>("Button1");
        _button2 = root.Q<Button>("Button2");
        _button3= root.Q<Button>("Button3");
        _button4 = root.Q<Button>("Button4");

        _menuDownButton.style.display = DisplayStyle.None;

        _menuUpButton.RegisterCallback<ClickEvent>(OnMenuUpClicked);
        _menuDownButton.RegisterCallback<ClickEvent>(OnMenuDownClicked);
        _button1.RegisterCallback<ClickEvent>(OnButton1);
        _button2.RegisterCallback<ClickEvent>(OnButton2);
        _button3.RegisterCallback<ClickEvent>(OnButton3);
        _button4.RegisterCallback<ClickEvent>(OnButton4);
    }

    private void OnButton4(ClickEvent evt)
    {
        Camera.main.transform.position = new Vector3(-0.437642127f,-0.96222508f,-2.95692205f);
        Camera.main.transform.rotation = new Quaternion(0.0744367018f,-0.719848573f,-0.0774092749f,-0.685773373f);
    }

    private void OnButton3(ClickEvent evt)
    {
        Camera.main.transform.position = new Vector3(8.85053444f,0.739149213f,-2.92854404f);
        Camera.main.transform.rotation = new Quaternion(0.0539232567f,-0.700960815f,0.0526041538f,0.709210217f);
    }

    private void OnButton2(ClickEvent evt)
    {
        Camera.main.transform.position = new Vector3(-2.65762424f,0.551858068f,-0.23476696f);
        Camera.main.transform.rotation = new Quaternion(0.0321886092f,0.885528922f,-0.0631096512f,0.459151f);
    }

    private void OnButton1(ClickEvent evt)
    {
        Camera.main.transform.position = new Vector3(8.09947395f,-0.538713932f,0.259789914f);
        Camera.main.transform.rotation = new Quaternion(0.0267208237f,0.894060671f,0.0549046546f,-0.443764687f);
    }

    private void OnMenuUpClicked(ClickEvent evt)
    {
        _menuDownButton.style.display = DisplayStyle.Flex;
        _menuUpButton.style.display = DisplayStyle.None;
        _lowerCanvas.AddToClassList("dropMenu--up");
    }
    private void OnMenuDownClicked(ClickEvent evt)
    {
        _menuDownButton.style.display = DisplayStyle.None;
        _menuUpButton.style.display = DisplayStyle.Flex;
        _lowerCanvas.RemoveFromClassList("dropMenu--up");
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
