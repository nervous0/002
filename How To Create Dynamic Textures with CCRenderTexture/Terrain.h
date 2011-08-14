//
//  Terrain.h
//  How To Create Dynamic Textures with CCRenderTexture
//
//  Created by 경민 이 on 11. 8. 13..
//  Copyright 2011 2km. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class HelloWorldLayer;

#define kMaxHillKeyPoints 1000
#define kHillSegmentWidth 10

#define kMaxHillVertices 4000
#define kMaxBorderVertices 800 

@interface Terrain : CCNode {
    int _offsetX;
    CGPoint _hillKeyPoints[kMaxHillKeyPoints];
    CCSprite *_stripes;
    
    int _fromKeyPointI;
    int _toKeyPointI;
    
    // Add some new instance variables inside the @interface
    int _nHillVertices;
    CGPoint _hillVertices[kMaxHillVertices];
    CGPoint _hillTexCoords[kMaxHillVertices];
    int _nBorderVertices;
    CGPoint _borderVertices[kMaxBorderVertices];
}

@property (retain) CCSprite * stripes;

- (void) setOffsetX:(float)newOffsetX;


@end
