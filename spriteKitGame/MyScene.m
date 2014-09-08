//
//  MyScene.m
//  spriteKitGame
//
//  Created by Apollo on 06/09/14.
//  Copyright (c) 2014 com.iosHello. All rights reserved.
//

#import "MyScene.h"

@interface MyScene ()
{
    SKSpriteNode* _bird;
    SKColor *_skyColor;
}
@end

@implementation MyScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.pipeGap = 100;
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.0);
        _skyColor = [SKColor colorWithRed:113.0/255.0 green:197.0/255.0 blue:207.0/255.0 alpha:1.0];
        [self setBackgroundColor:_skyColor];
        
        SKTexture *birdTexture1 = [SKTexture textureWithImageNamed:@"Bird1"];
        birdTexture1.filteringMode = SKTextureFilteringNearest;
        
        SKTexture *birdTexture2 = [SKTexture textureWithImageNamed:@"Bird2"];
        birdTexture2.filteringMode = SKTextureFilteringNearest;
        
        SKAction *flap = [SKAction repeatActionForever:[SKAction animateWithTextures:@[birdTexture1, birdTexture2] timePerFrame:0.2]];
        
        _bird = [SKSpriteNode spriteNodeWithTexture:birdTexture1];
        [_bird setScale:2.0];
        _bird.position = CGPointMake(self.frame.size.width / 4, CGRectGetMidY(self.frame));
        [_bird runAction:flap];
        
        _bird.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_bird.size.height / 2];
        _bird.physicsBody.dynamic = YES;
        _bird.physicsBody.allowsRotation = NO;
        [self addChild:_bird];
        [self initGround];
        [self initSky];
        
        SKTexture* _pipeTexture1 = [SKTexture textureWithImageNamed:@"Pipe1"];
        _pipeTexture1.filteringMode = SKTextureFilteringNearest;
        SKTexture* _pipeTexture2 = [SKTexture textureWithImageNamed:@"Pipe2"];
        _pipeTexture2.filteringMode = SKTextureFilteringNearest;
        
        SKNode* pipePair = [SKNode node];
        pipePair.position = CGPointMake( self.frame.size.width + _pipeTexture1.size.width * 2, 0 );
        pipePair.zPosition = -10;
        
        CGFloat y = arc4random() % (NSInteger)( self.frame.size.height / 3 );
        
        SKSpriteNode* pipe1 = [SKSpriteNode spriteNodeWithTexture:_pipeTexture1];
        [pipe1 setScale:2];
        pipe1.position = CGPointMake( 0, y );
        pipe1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pipe1.size];
        pipe1.physicsBody.dynamic = NO;
        [pipePair addChild:pipe1];
        
        SKSpriteNode* pipe2 = [SKSpriteNode spriteNodeWithTexture:_pipeTexture2];
        [pipe2 setScale:2];
        pipe2.position = CGPointMake( 0, y + pipe1.size.height + self.pipeGap);
        pipe2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pipe2.size];
        pipe2.physicsBody.dynamic = NO;
        [pipePair addChild:pipe2];
        
        SKAction* movePipes = [SKAction repeatActionForever:[SKAction moveByX:-1 y:0 duration:0.02]];
        [pipePair runAction:movePipes];
        
        [self addChild:pipePair];
    }
    return self;
}

-(void)initGround
{
    SKTexture *groundTexture = [SKTexture textureWithImageNamed:@"Ground"];
    groundTexture.filteringMode = SKTextureFilteringNearest;
    SKAction *moveGroundSprite = [SKAction moveByX:-groundTexture.size.width*2 y:0 duration:0.01 * groundTexture.size.width*2];
    SKAction *resetGroundSprite = [SKAction moveByX:groundTexture.size.width*2 y:0 duration:0];
    SKAction *moveGroundSpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveGroundSprite, resetGroundSprite]]];
    for (int i = 0; i < 2 + self.frame.size.width / (groundTexture.size.width * 2); ++i)
    {
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:groundTexture];
        [sprite setScale:2.0];
        sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height /2);
        [sprite runAction:moveGroundSpritesForever];
        [self addChild:sprite];
    }
    
    SKNode *dummy = [SKNode node];
    dummy.position = CGPointMake(0, groundTexture.size.height);
    dummy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, groundTexture.size.height * 2)];
    dummy.physicsBody.dynamic = NO;
    [self addChild:dummy];
}

-(void)initSky
{
    SKTexture *skylineTexture = [SKTexture textureWithImageNamed:@"Skyline"];
    skylineTexture.filteringMode = SKTextureFilteringNearest;
    SKAction *moveSkySprite = [SKAction moveByX:-skylineTexture.size.width * 2 y:0 duration:0.5 * skylineTexture.size.width *2];
    SKAction *resetSkySprite = [SKAction moveByX:skylineTexture.size.width * 2 y:0 duration:0];
    SKAction *moveSkySpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveSkySprite, resetSkySprite]]];
    for (int i = 0; i < 2 + self.frame.size.width / (skylineTexture.size.width * 2); ++i)
    {
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:skylineTexture];
        [sprite setScale:2.0];
        sprite.zPosition = - 20;
        [sprite runAction:moveSkySpritesForever];
        sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2 + skylineTexture.size.height * 2);
        [self addChild:sprite];
    }
    
    SKNode *skyLimit = [SKNode node];
    skyLimit.position = CGPointMake(0, self.frame.size.height);
    skyLimit.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, 1)];
    skyLimit.physicsBody.dynamic = NO;
    [self addChild:skyLimit];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_bird.physicsBody applyImpulse:CGVectorMake(0, 0)];
    [_bird.physicsBody applyImpulse:CGVectorMake(0, 8)];
}

-(CGFloat)rotateBird:(CGFloat)value
{
    if (value > 0.5)
        return (0.5);
    else if (value < -1)
        return -1;
    else
        return value;
}

-(void)update:(CFTimeInterval)currentTime
{
    _bird.zRotation = [self rotateBird:((_bird.physicsBody.velocity.dy * (_bird.physicsBody.velocity.dy < 0 ? 0.003 : 0.001)))];
}


@end
