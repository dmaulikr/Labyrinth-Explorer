//
//  SharedAssetManagement.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 3/17/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import SpriteKit

protocol SharedAssetProvider {
    static func loadSharedAssets()
}

enum CharacterType {
    case Hero, EnemyWithSword, EnemyWithGun
}

func inferCharacterType(fromType: GameCharacter.Type) -> CharacterType {
    switch fromType {
    case is RonCharacter.Type:
        return CharacterType.Hero
    case is EnemyWithSword.Type:
        return CharacterType.EnemyWithSword
    case is EnemyWithGun.Type:
        return CharacterType.EnemyWithGun
    default:
        fatalError("Unknown type provided for \(__FUNCTION__).")
    }
}

struct SharedTextures {
    struct Keys {
        static var idle = "textures.idle"
        static var walk = "textures.walk"
        static var attack = "textures.attack"
        static var hit = "textures.hit"
        static var death = "textures.death"
        static var slide = "textures.slide"
        static var sneak = "textures.sneak"
        static var run = "textures.run"
        static var alarm = "textures.alarm"
        static var inspect = "textures.inspect"
    }
    
    static var textures = [CharacterType: [String: [SKTexture]]]()
}

struct SharedSprites {
    struct Keys {
        static var projectile = "sprites.projectile"
        //static var deathSplort = "sprites.deathSplort"
    }
    
    static var sprites = [CharacterType: [String: Projectile]]()
}

// Holds shared emitters for the various character types. Keys are provided for the inner dictionary.
struct SharedEmitters {
    struct Keys {
        static var damage = "emitters.damage"
        //static var death = "emitters.death"
        static var projectile = "emitters.projectile"
    }
    
    static var emitters = [CharacterType: [String: SKEmitterNode]]()
}

// Holds shared actions for the various character types. Keys are provided for the inner dictionary.
struct SharedActions {
    struct Keys {
        static var damage = "actions.damage"
    }
    
    static var actions = [CharacterType: [String: SKAction]]()
}

