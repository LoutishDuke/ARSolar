//
//  ViewController.swift
//  ARSolar
//
//  Created by Shane Harrigan on 17/05/2020.
//  Copyright © 2020 Shane Harrigan. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {
    

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var picker: UIPickerView!
    
    var bodyModelArr : [BodyModel] = [BodyModel]()
    var node : SCNNode = SCNNode()
    var pickerData : [String] = [String]()
    var selectedBody : Int = 0
    
    func populateBodyModelArray() {
        let solModel = BodyModel(bodyName: "Sol", imageFile: "art.scnassets/sun.jpg", radius: 0.6)
        let earthModel = BodyModel(bodyName: "Earth", imageFile: "art.scnassets/earth.jpg", radius: 0.2)
        let moonModel = BodyModel(bodyName: "Moon", imageFile: "art.scnassets/moon.jpg", radius: 0.1)
        
        
        self.bodyModelArr.append(solModel)
        self.bodyModelArr.append(earthModel)
        self.bodyModelArr.append(moonModel)
    }
    
    func getBodyNames() -> [String] {
        var arr : [String] = []
        for s in self.bodyModelArr{
            arr.append(s.bodyName)
        }
        return arr
    }
    
    func setModelTexture(){
        let sphere = SCNSphere(radius: CGFloat(bodyModelArr[selectedBody].radius))
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: bodyModelArr[selectedBody].imageFile)
        sphere.materials = [material]
        
        self.node.geometry = sphere
        sceneView.scene.rootNode.addChildNode(self.node)
        sceneView.autoenablesDefaultLighting = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        populateBodyModelArray()
        
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        pickerData = getBodyNames()
        
        
        
        self.node.position = SCNVector3(0, 0.1, -2)
        
        setModelTexture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var configuration : ARConfiguration? = AROrientationTrackingConfiguration()
        if ARWorldTrackingConfiguration.isSupported {
            // Create a session configuration
            configuration = ARWorldTrackingConfiguration()
        }
        // Run the view's session
        sceneView.session.run(configuration!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedBody = row
        self.setModelTexture()
    }
}
