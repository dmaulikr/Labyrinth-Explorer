//
//  GameCharacter.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 3/16/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import SpriteKit

enum AnimationState: UInt32 {
    case Idle = 0, Walk, Attack, GetHit, Death, LeanSliding, SneakUp, Run, Alarmed, Inspect
}

struct PhysicsCategory {
    static let None : UInt32 = 0 //0
    static let All : UInt32 = UInt32.max //4294967295
    static let LivingCreatures: UInt32 = PhysicsCategory.Player | PhysicsCategory.Enemy
    static let UsableItem : UInt32 = 0b10 //2
    static let DetectionArea : UInt32 = 0b11 //3
    static let Player: UInt32 = 0b1010 //10
    static let Enemy : UInt32 = 0b1011 //11
    static let Projectile : UInt32 = 0b1100 //12
    static let Trap : UInt32 = 0b1101 //13
    static let BlockingTrap : UInt32 = 0b1110 //14
    static let TrapEmitter : UInt32 = 0b1111 //15
    static let MineBomb : UInt32 = 0b10000 //16
    static let Door : UInt32 = 0b110000 //48
    static let Undestroyable : UInt32 = 0b110001 //49
    static let Wall : UInt32 = 0b110010 //50
}

class GameCharacter: SKSpriteNode {
    
    // MARK: Properties
    
    var isDying = false
    var isAttacking = false
    var characterHurts = false
    var trapEmitterInAction = false
    var animated = true
    var animationSpeed: CGFloat = 1.0/28.0
    var movementSpeed: CGFloat = 6
    var requestedAnimation = AnimationState.Idle
    var collisionRadius: CGFloat = 20.0
    var paths:[SKNode] = []
    
    class var characterType: CharacterType {
        return inferCharacterType(self)
    }
    
    class var idleAnimationFrames: [SKTexture] {
        get {
        return SharedTextures.textures[characterType]?[SharedTextures.Keys.idle] ?? []
        }
        set {
            var texturesForCharacterType = SharedTextures.textures[characterType] ?? [String: [SKTexture]]()
            texturesForCharacterType[SharedTextures.Keys.idle] = newValue
            SharedTextures.textures[characterType] = texturesForCharacterType
        }
    }
    
    class var walkAnimationFrames: [SKTexture] {
        get {
        return SharedTextures.textures[characterType]?[SharedTextures.Keys.walk] ?? []
        }
        set {
            var texturesForCharacterType = SharedTextures.textures[characterType] ?? [String: [SKTexture]]()
            texturesForCharacterType[SharedTextures.Keys.walk] = newValue
            SharedTextures.textures[characterType] = texturesForCharacterType
        }
    }
    
    class var getHitAnimationFrames: [SKTexture] {
        get {
        return SharedTextures.textures[characterType]?[SharedTextures.Keys.hit] ?? []
        }
        set {
            var texturesForCharacterType = SharedTextures.textures[characterType] ?? [String: [SKTexture]]()
            texturesForCharacterType[SharedTextures.Keys.hit] = newValue
            SharedTextures.textures[characterType] = texturesForCharacterType
        }
    }
    
    class var deathAnimationFrames: [SKTexture] {
        get {
        return SharedTextures.textures[characterType]?[SharedTextures.Keys.death] ?? []
        }
        set {
            var texturesForCharacterType = SharedTextures.textures[characterType] ?? [String: [SKTexture]]()
            texturesForCharacterType[SharedTextures.Keys.death] = newValue
            SharedTextures.textures[characterType] = texturesForCharacterType
        }
    }
    
    class var attackAnimationFrames: [SKTexture] {
        get {
        return SharedTextures.textures[characterType]?[SharedTextures.Keys.attack] ?? []
        }
        set {
            var texturesForCharacterType = SharedTextures.textures[characterType] ?? [String: [SKTexture]]()
            texturesForCharacterType[SharedTextures.Keys.attack] = newValue
            SharedTextures.textures[characterType] = texturesForCharacterType
        }
    }
    
    class var leanSlidingAnimationFrames: [SKTexture] {
        get {
        return SharedTextures.textures[characterType]?[SharedTextures.Keys.slide] ?? []
        }
        set {
            var texturesForCharacterType = SharedTextures.textures[characterType] ?? [String: [SKTexture]]()
            texturesForCharacterType[SharedTextures.Keys.slide] = newValue
            SharedTextures.textures[characterType] = texturesForCharacterType
        }
    }
    
    class var sneakUpAnimationFrames: [SKTexture] {
        get {
        return SharedTextures.textures[characterType]?[SharedTextures.Keys.sneak] ?? []
        }
        set {
            var texturesForCharacterType = SharedTextures.textures[characterType] ?? [String: [SKTexture]]()
            texturesForCharacterType[SharedTextures.Keys.sneak] = newValue
            SharedTextures.textures[characterType] = texturesForCharacterType
        }
    }
    
    class var runAnimationFrames: [SKTexture] {
        get {
        return SharedTextures.textures[characterType]?[SharedTextures.Keys.run] ?? []
        }
        set {
            var texturesForCharacterType = SharedTextures.textures[characterType] ?? [String: [SKTexture]]()
            texturesForCharacterType[SharedTextures.Keys.run] = newValue
            SharedTextures.textures[characterType] = texturesForCharacterType
        }
    }
    
    class var alarmedAnimationFrames: [SKTexture] {
        get {
        return SharedTextures.textures[characterType]?[SharedTextures.Keys.alarm] ?? []
        }
        set {
            var texturesForCharacterType = SharedTextures.textures[characterType] ?? [String: [SKTexture]]()
            texturesForCharacterType[SharedTextures.Keys.alarm] = newValue
            SharedTextures.textures[characterType] = texturesForCharacterType
        }
    }
    
    class var inspectAnimationFrames: [SKTexture] {
        get {
        return SharedTextures.textures[characterType]?[SharedTextures.Keys.inspect] ?? []
        }
        set {
            var texturesForCharacterType = SharedTextures.textures[characterType] ?? [String: [SKTexture]]()
            texturesForCharacterType[SharedTextures.Keys.inspect] = newValue
            SharedTextures.textures[characterType] = texturesForCharacterType
        }
    }
    
    class var projectile: Projectile {
        get {
        return SharedSprites.sprites[characterType]?[SharedSprites.Keys.projectile] ?? Projectile()
        }
        set {
            var spritesForCharacterType = SharedSprites.sprites[characterType] ?? [String: Projectile]()
            spritesForCharacterType[SharedSprites.Keys.projectile] = newValue
            SharedSprites.sprites[characterType] = spritesForCharacterType
        }
    }
    
    class var damageEmitter: SKEmitterNode {
        get {
        return SharedEmitters.emitters[characterType]?[SharedEmitters.Keys.damage] ?? SKEmitterNode()
        }
        set {
            var emittersForCharacterType = SharedEmitters.emitters[characterType] ?? [String: SKEmitterNode]()
            emittersForCharacterType[SharedEmitters.Keys.damage] = newValue
            SharedEmitters.emitters[characterType] = emittersForCharacterType
        }
    }
    
    /*class var deathEmitter: SKEmitterNode {
        get {
        return SharedEmitters.emitters[characterType]?[SharedEmitters.Keys.death] ?? SKEmitterNode()
        }
        set {
            var emittersForCharacterType = SharedEmitters.emitters[characterType] ?? [String: SKEmitterNode]()
            emittersForCharacterType[SharedEmitters.Keys.death] = newValue
            SharedEmitters.emitters[characterType] = emittersForCharacterType
        }
    }*/
    
    class var projectileEmitter: SKEmitterNode {
        get {
        return SharedEmitters.emitters[characterType]?[SharedEmitters.Keys.projectile] ?? SKEmitterNode()
        }
        set {
            var emittersForCharacterType = SharedEmitters.emitters[characterType] ?? [String: SKEmitterNode]()
            emittersForCharacterType[SharedEmitters.Keys.projectile] = newValue
            SharedEmitters.emitters[characterType] = emittersForCharacterType
        }
    }
    
    class var damageAction: SKAction {
        get {
        return SharedActions.actions[characterType]?[SharedActions.Keys.damage] ?? SKAction()
        }
        set {
            var actionsForCharacterType = SharedActions.actions[characterType] ?? [String: SKAction]()
            actionsForCharacterType[SharedActions.Keys.damage] = newValue
            SharedActions.actions[characterType] = actionsForCharacterType
        }
    }
    
    // MARK: Scene Processing Support
    
    func updateWithTimeSinceLastUpdate(interval: NSTimeInterval) {
        if !animated {
            return
        }
        resolveRequestedAnimation()
    }
    
    func animationDidComplete(animation: AnimationState) {}
    
    func rotateCharacterToAngle(angleToRotate:CGFloat, duration:NSTimeInterval) {
        runAction(SKAction.rotateToAngle(angleToRotate, duration: duration))
    }
    
    // MARK: Character Animation
    
    func resolveRequestedAnimation() {
        
        var (frames, key) = animationFramesAndKeyForState(requestedAnimation)
        
        fireAnimationForState(requestedAnimation, usingTextures: frames, withKey: key)
        
        if characterHurts {
            requestedAnimation = .GetHit
        }
        else {
            requestedAnimation = isDying ? .Death : .Idle
        }
        
    }
    
    func animationFramesAndKeyForState(state: AnimationState) -> ([SKTexture], String) {
        switch state {
        case .Walk:
            return (self.dynamicType.walkAnimationFrames, "anim_walk")
            
        case .Attack:
            return (self.dynamicType.attackAnimationFrames, "anim_attack")
            
        case .GetHit:
            return (self.dynamicType.getHitAnimationFrames, "anim_gethit")
            
        case .Death:
            return (self.dynamicType.deathAnimationFrames, "anim_death")
            
        case .Idle:
            return (self.dynamicType.idleAnimationFrames, "anim_idle")
            
        case .LeanSliding:
            return (self.dynamicType.leanSlidingAnimationFrames, "anim_leansliding")
            
        case .SneakUp:
            return (self.dynamicType.sneakUpAnimationFrames, "anim_sneakup")
            
        case .Run:
            return (self.dynamicType.runAnimationFrames, "anim_run")
            
        case .Alarmed:
            return (self.dynamicType.alarmedAnimationFrames, "anim_alarm")
            
        case .Inspect:
            return (self.dynamicType.inspectAnimationFrames, "anim_inspect")
        }
    }
    
    func fireAnimationForState(animationState: AnimationState, usingTextures frames: [SKTexture], withKey key: String) {
        let animAction = actionForKey(key)
        
        if animAction != nil || frames.count < 1 {
            return
        }
        
        let animationAction = SKAction.animateWithTextures(frames, timePerFrame: NSTimeInterval(animationSpeed), resize: true, restore: false)
        let blockAction = SKAction.runBlock {
            self.animationHasCompleted(animationState)
        }
        
        runAction(SKAction.sequence([animationAction, blockAction]), withKey: key)
    }
    
    func animationHasCompleted(animationState: AnimationState) {
        if isDying {
            animated = false
        }
        
        animationDidComplete(animationState)
        
        if isAttacking {
            isAttacking = false
        }
    }
    
    // MARK: Initializers
    
    convenience init(texture: SKTexture?, atPosition position: CGPoint) {
        let size = texture != nil ? texture!.size() : CGSize(width: 0, height: 0)
        self.init(texture: texture, color: SKColor.whiteColor(), size: size)
        self.position = position
    }
    
    // MARK: Setup
    
    func configurePhysicsBody() {}
    
    func collidedWith(other: SKPhysicsBody) {}
    
    func controlLivesCount(decrease decrease:Bool, count:Int) {}
    
}
