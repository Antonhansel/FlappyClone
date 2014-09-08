//
//  MyScene.h
//  spriteKitGame
//

//  Copyright (c) 2014 com.iosHello. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene

@property (nonatomic, assign) NSInteger pipeGap;

-(void)initSky;
-(void)initGround;
-(CGFloat)rotateBird:(CGFloat) value;


@end
