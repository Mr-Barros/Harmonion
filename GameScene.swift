//
//  GameScene.swift
//  Harmonion
//
//  Created by Davi Martignoni Barros on 31/01/24.
//

import Foundation
import SwiftUI
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    @ObservedObject var appRouter: AppRouter
    var timer: TimerController
    
    let floorCategory: UInt32 = 0x1 << 0
    let knightCategory: UInt32 = 0x1 << 1
    let dragonCategory: UInt32 = 0x1 << 2
    let fireballCategory: UInt32 = 0x1 << 3
    let slashEffectCategory: UInt32 = 0x1 << 4
    
    var noMoveCount = 0
    var eventCount = 0
    
    init(appRouter: AppRouter, timer: TimerController, size: CGSize) {
        self.appRouter = appRouter
        self.timer = timer
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var background: SKSpriteNode = {
        let background = SKSpriteNode(imageNamed: "background")
        background.setScale(self.frame.width / background.frame.width)
        background.position.x = 0
        background.position.y = -self.frame.height * 0.15
        return background
    } ()
    
    lazy var floor: SKShapeNode = {
        let floor = SKShapeNode(rectOf: CGSize(width: self.frame.width, height: self.frame.height * 0.1))
        floor.strokeColor = .clear
        floor.position.y = self.frame.minY + floor.frame.height / 2
        
        floor.physicsBody = SKPhysicsBody(rectangleOf: floor.frame.size)
        floor.physicsBody?.isDynamic = false
        floor.physicsBody?.categoryBitMask = floorCategory
        floor.physicsBody?.contactTestBitMask = knightCategory
        floor.physicsBody?.restitution = 0
        return floor
    } ()
    
    lazy var knight: SKSpriteNode = {
        let knight = SKSpriteNode(imageNamed: "knight")
        knight.setScale(0.1 * self.frame.width / knight.frame.width)
        knight.position = CGPoint(x: self.frame.minX + self.frame.width * 0.2,
                                  y: self.frame.minY + self.frame.height * 0.1 + knight.frame.height / 2)
        
        knight.physicsBody = SKPhysicsBody(rectangleOf: knight.size)
        knight.physicsBody?.affectedByGravity = true
        knight.physicsBody?.allowsRotation = true
        knight.physicsBody?.categoryBitMask = knightCategory
        knight.physicsBody?.collisionBitMask = 1
        knight.physicsBody?.restitution = 0
        return knight
    } ()
    
    lazy var dragon: SKSpriteNode = {
        let dragon = SKSpriteNode(imageNamed: "dragon-flying")
        dragon.setScale(0.3 * self.frame.width / dragon.frame.width)
        dragon.position = CGPoint(x: self.frame.maxX + dragon.frame.width / 2,
                                  y: self.frame.height * 0.3)
        
        
        dragon.physicsBody = SKPhysicsBody(rectangleOf: dragon.size)
        dragon.physicsBody?.affectedByGravity = false
        dragon.physicsBody?.allowsRotation = false
        dragon.physicsBody?.categoryBitMask = dragonCategory
        dragon.physicsBody?.collisionBitMask = 1
        return dragon
    } ()
    
    lazy var fireball: SKSpriteNode = {
        let fireball = SKSpriteNode(imageNamed: "fireball")
        fireball.setScale(0.15 * self.frame.width / fireball.frame.width)
        fireball.position.x = -dragon.frame.width * 1.1
        fireball.position.y = -dragon.frame.height * 0.25
        fireball.zRotation = -.pi / 4
        
        fireball.physicsBody = SKPhysicsBody(rectangleOf: fireball.size)
        fireball.physicsBody?.categoryBitMask = fireballCategory
        fireball.physicsBody?.contactTestBitMask = knightCategory
        fireball.physicsBody?.collisionBitMask = 1
        return fireball
    } ()
    
    lazy var slashEffect: SKSpriteNode = {
        let slashEffect = SKSpriteNode(imageNamed: "slash-effect")
        slashEffect.setScale(0.3 * self.frame.width / slashEffect.frame.width)
        slashEffect.position.x = knight.frame.width * 1.1
        slashEffect.position.y = knight.frame.height * 0.25
        slashEffect.zRotation = 0
        
        slashEffect.physicsBody = SKPhysicsBody(rectangleOf: slashEffect.size)
        slashEffect.physicsBody?.categoryBitMask = slashEffectCategory
        slashEffect.physicsBody?.contactTestBitMask = dragonCategory
        slashEffect.physicsBody?.collisionBitMask = 1
        return slashEffect
    } ()
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -20)
        backgroundColor = .systemCyan
        addChild(background)
        addChild(floor)
        addChild(knight)
        addChild(dragon)
        battle()
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch contactMask {
        case knightCategory | floorCategory:
            knight.texture = SKTexture(imageNamed: "knight")
        case knightCategory | fireballCategory:
            if contact.bodyA.categoryBitMask == fireballCategory {
                contact.bodyA.node?.removeFromParent()
            } else if contact.bodyB.categoryBitMask == fireballCategory {
                contact.bodyB.node?.removeFromParent()
            }
            knightDamaged()
        case dragonCategory | slashEffectCategory:
            if contact.bodyA.categoryBitMask == slashEffectCategory {
                contact.bodyA.node?.removeFromParent()
            } else if contact.bodyB.categoryBitMask == slashEffectCategory {
                contact.bodyB.node?.removeFromParent()
            }
            dragonDamaged()
        default:
            break
        }
    }
    
    func jump() {
        knight.texture = SKTexture(imageNamed: "knight-jumping")
        knight.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 2.5 * self.frame.height))
    }
    
    func throwFireball() {
        let fireball = fireball.copy() as? SKSpriteNode
        dragon.addChild(fireball ?? self.fireball)
        let destination = CGPoint(x: self.frame.minX,
                                  y: self.frame.minY + self.frame.height * 0.3)
        let move = SKAction.move(to: convert(destination, to: dragon),
                                 duration: 0.7)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([move, removeAction])
        fireball?.run(sequence)
    }
    
    func attack() {
        let textures: [SKTexture] = [SKTexture(imageNamed: "knight-attacking"),
                                     SKTexture(imageNamed: "knight")]
        let animation = SKAction.animate(with: textures, timePerFrame: 0.4)
        let slashEffect = slashEffect.copy() as? SKSpriteNode
        knight.addChild(slashEffect ?? self.slashEffect)
        let destination = CGPoint(x: self.frame.maxX,
                                  y: self.frame.minY + self.frame.height * 0.6)
        let move = SKAction.move(to: convert(destination, to: knight),
                                 duration: 1)
        let scale = SKAction.scale(by: 3, duration: 1)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([move, removeAction])
        slashEffect?.run(scale)
        slashEffect?.run(sequence)
        knight.run(animation)
    }
    
    func flyIn() {
        let destination = CGPoint(x: self.frame.minX + self.frame.width * 0.8,
                                  y: self.frame.minY + self.frame.height * 0.1 + dragon.frame.height / 2)
        let move = SKAction.move(to: destination, duration: 1.2)
        let setTexture = SKAction.setTexture(SKTexture(imageNamed: "dragon"))
        let sequence = SKAction.sequence([move, setTexture])
        dragon.run(sequence)
    }
    
    func flyAway() {
        dragon.xScale = -0.3
        let destination = CGPoint(x: self.frame.maxX + dragon.frame.width / 2,
                                  y: self.frame.height * 0.3)
        let move = SKAction.move(to: destination, duration: 1.2)
        let setTexture = SKAction.setTexture(SKTexture(imageNamed: "dragon-flying"))
        let sequence = SKAction.sequence([setTexture, move])
        dragon.run(sequence)
    }
    
    func knightDamaged() {
        let setTexture = SKAction.setTexture(SKTexture(imageNamed: "knight-damaged"))
        let wait = SKAction.wait(forDuration: 0.5)
        let setTextureBack = SKAction.setTexture(SKTexture(imageNamed: "knight"))
        let sequence = SKAction.sequence([setTexture, wait, setTextureBack])
        knight.run(sequence)
    }
    
    func dragonDamaged() {
        let setTexture = SKAction.setTexture(SKTexture(imageNamed: "dragon-damaged"))
        let wait = SKAction.wait(forDuration: 0.5)
        let setTextureBack = SKAction.setTexture(SKTexture(imageNamed: "dragon"))
        let sequence = SKAction.sequence([setTexture, wait, setTextureBack])
        dragon.run(sequence)
    }
    
    func event() {
        let random = noMoveCount < 2 ? Int.random(in: 0...2) : Int.random(in: 0...1)
        if random == 0 {
            throwFireball()
            if timer.isRunning {
                jump()
            }
            noMoveCount = 0
        } else if random == 1 {
            if timer.isRunning {
                attack()
            } else {
                throwFireball()
            }
            noMoveCount = 0
        } else {
            noMoveCount += 1
        }
    }
    
    func battle() {
        let wait = SKAction.wait(forDuration: 1.2)
        let event = SKAction.run {
            self.event()
        }
        let attack = SKAction.run {
            self.attack()
        }
        let flyIn = SKAction.run {
            self.flyIn()
        }
        let flyAway = SKAction.run {
            self.flyAway()
        }
        let end = SKAction.run {
            self.appRouter.router = .end
        }
        let eventSequence = SKAction.sequence([wait, event])
        let repeatAction = SKAction.repeat(eventSequence, count: 48)
        let battleSequence = SKAction.sequence([flyIn, wait, repeatAction, wait, attack, wait, flyAway, wait, end])
        self.run(battleSequence)
    }
}
