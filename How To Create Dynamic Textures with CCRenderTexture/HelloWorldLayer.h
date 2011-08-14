//
//  HelloWorldLayer.h
//  How To Create Dynamic Textures with CCRenderTexture
//
//  Created by Kyungmin Lee on 11. 8. 12..
//  Copyright 2km 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "Terrain.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    CCSprite* _backgroud;
    Terrain* _terrain;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
