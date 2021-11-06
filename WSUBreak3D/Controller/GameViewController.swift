//
//  GameViewController.swift
//  WSUBreak3D
//
//  Created by wsucatslabs on 10/29/21.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    @IBOutlet var scoreLabel : UILabel?
    @IBOutlet var scnView : SCNView?
    var gameLogic = BreakScene(named: "art.scnassets/Break.scn")!
    
    @objc func scoreDidChange(notification : Notification) {
        DispatchQueue.main.async {
            let score = (notification.object as! NSObject).value(forKey:"score") as! NSNumber
            self.scoreLabel!.text = "\(score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameLogic.setup()

        scnView!.scene = gameLogic
        scnView!.showsStatistics = true
        scnView!.delegate = gameLogic
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.scoreDidChange), name: NSNotification.Name("scoreDidChange"), object: nil)
    }
    
    @IBAction func movePaddle(recognizer : UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        gameLogic.movePaddle(translation: translation)
    }
}
