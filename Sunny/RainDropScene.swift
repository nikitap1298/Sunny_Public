//
//  GameScene.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 30.05.23.
//

import SwiftUI
import SpriteKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        // Create a background color
        backgroundColor = OnboardingColors.backgroundBottom ?? .black
        
        // Create raindrop sprite
        let raindrop = SKSpriteNode(imageNamed: "AndMore_Screen")
        
        // Set initial position for the raindrop
        raindrop.position = CGPoint(x: size.width / 2, y: size.height + raindrop.size.height)
        addChild(raindrop)
        
        // Create an action to move the raindrop downwards
        let moveAction = SKAction.moveTo(y: -raindrop.size.height, duration: 1.5)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveAction, removeAction])
        let repeatForever = SKAction.repeatForever(sequence)
        
        // Spawn and move raindrops continuously
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run(spawnRaindrop),
            SKAction.wait(forDuration: 0.1)
        ])))
    }
    
    func spawnRaindrop() {
        let raindrop = SKSpriteNode(imageNamed: "AndMore_Screen")
        
        // Randomly position the raindrop horizontally
        let randomX = CGFloat.random(in: 0..<size.width)
        raindrop.position = CGPoint(x: randomX, y: size.height + raindrop.size.height)
        addChild(raindrop)
        
        // Create an action to move the raindrop downwards
        let moveAction = SKAction.moveTo(y: -raindrop.size.height, duration: 1.5)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveAction, removeAction])
        raindrop.run(sequence)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Perform any necessary updates
    }
}
