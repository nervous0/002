//
//  HelloWorldLayer.mm
//  How To Create Dynamic Textures with CCRenderTexture
//
//  Created by Kyungmin Lee on 11. 8. 12..
//  Copyright 2km 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};


// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(CCSprite *)stripedSpriteWithColor1:(ccColor4F)c1 
                              color2:(ccColor4F)c2 
                         textureSize:(float)textureSize
                             stripes:(int)nStripes {  
     
    // 1: Create new CCRenderTexture
    CCRenderTexture *rt = [CCRenderTexture renderTextureWithWidth:textureSize height:textureSize];
    
    // 2: Call CCRenderTexture:begin
    [rt beginWithClear:c1.r g:c1.g b:c1.b a:c1.a];
    
    // 3: Draw into the texture    
    
    // Layer 1: Stripes
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
    
    CGPoint vertices[nStripes*6];
    int nVertices = 0;
    float x1 = -textureSize;
    float x2;
    float y1 = textureSize;
    float y2 = 0;
    float dx = textureSize / nStripes * 2;
    float stripeWidth = dx/2;
    for (int i=0; i<nStripes; i++) {
        x2 = x1 + textureSize;
        vertices[nVertices++] = CGPointMake(x1, y1);
        vertices[nVertices++] = CGPointMake(x1+stripeWidth, y1);
        vertices[nVertices++] = CGPointMake(x2, y2);
        vertices[nVertices++] = vertices[nVertices-2];
        vertices[nVertices++] = vertices[nVertices-2];
        vertices[nVertices++] = CGPointMake(x2+stripeWidth, y2);
        x1 += dx;
    }
    
    glColor4f(c2.r, c2.g, c2.b, c2.a);
    glVertexPointer(2, GL_FLOAT, 0, vertices);
    glDrawArrays(GL_TRIANGLES, 0, (GLsizei)nVertices);
    
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glEnable(GL_TEXTURE_2D);
    
    // Layer 2: Noise    
//    CCSprite *noise = [CCSprite spriteWithFile:@"Noise.png"];
    CCSprite* noise = [CCSprite spriteWithFile:@"scratch.jpg"];

    [noise setBlendFunc:(ccBlendFunc){GL_DST_COLOR, GL_ZERO}];
    noise.position = ccp(textureSize/2, textureSize/2);
    [noise visit];
    
    // 4: Call CCRenderTexture:end
    [rt end];
    
    // 5: Create a new Sprite from the texture
    return [CCSprite spriteWithTexture:rt.sprite.texture];
    
}

-(CCSprite*) spriteWithColor:(ccColor4F)bgColor textureSize:(float)textureSize{ 
    
    // Create new CCRenderTexture
    CCRenderTexture* rt = [CCRenderTexture renderTextureWithWidth:textureSize height:textureSize];
    
    // Call CCRenderTexture
    [rt beginWithClear:bgColor.r g:bgColor.g b:bgColor.b a:bgColor.a];
    
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    float gradientAlpha = 0.9;
    CGPoint vertices[4];
    ccColor4F colors[4];
    int nVertices = 0;
    
    vertices[nVertices] = CGPointMake(0, 0);
    colors[nVertices++] = (ccColor4F){0, 0, 0, 0 };
    vertices[nVertices] = CGPointMake(textureSize, 0);
    colors[nVertices++] = (ccColor4F){0, 0, 0, 0};
    vertices[nVertices] = CGPointMake(0, textureSize);
    colors[nVertices++] = (ccColor4F){0, 0, 0, gradientAlpha};
    vertices[nVertices] = CGPointMake(textureSize, textureSize);
    colors[nVertices++] = (ccColor4F){0, 0, 0, gradientAlpha};
    
    glVertexPointer(2, GL_FLOAT, 0, vertices);
    glColorPointer(4, GL_FLOAT, 0, colors);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei)nVertices);
    
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glEnable(GL_TEXTURE_2D);
    
    // Draw into the texture
    // Not yet
    CCSprite* noise = [CCSprite spriteWithFile:@"metal-texture.jpg"];
    [noise setBlendFunc:(ccBlendFunc){GL_DST_COLOR, GL_ZERO}];
    noise.position = ccp(textureSize/2,textureSize/2);
    [noise visit];
    
    // Call CCRenderTexture:end
    [rt end];
    
    return [CCSprite spriteWithTexture:rt.sprite.texture];
}

-(ccColor4F)randomBrightColor {
    while (true) {
        float requiredBrightness = 192;
        ccColor4B randomColor = ccc4(arc4random()%255, arc4random()%255, arc4random()%255, 255 );
        if( randomColor.r > requiredBrightness || 
            randomColor.g > requiredBrightness ||
            randomColor.b > requiredBrightness) {
            return ccc4FFromccc4B(randomColor);
        }
    }
}

-(void)genBackground {
    [_backgroud removeFromParentAndCleanup:YES];
    
    ccColor4F bgColor = [self randomBrightColor];
    ccColor4F stripeColor = [self randomBrightColor];
    
    //_backgroud = [self spriteWithColor:bgColor textureSize:512];
    int nStripes = ((arc4random() % 4) + 1) * 2;
    _backgroud = [self stripedSpriteWithColor1:bgColor color2:stripeColor textureSize:512 stripes:nStripes];
    
    self.scale = 0.5;
        
    CGSize winSize = [CCDirector sharedDirector].winSize;
    _backgroud.position = ccp(winSize.width/2 , winSize.height/2);
    
    ccTexParams tp = {GL_LINEAR, GL_LINEAR, GL_REPEAT , GL_REPEAT};
    [_backgroud.texture setTexParameters:&tp];
    
    [self addChild:_backgroud z:-1];
}


-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
		
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);

}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		[self genBackground];
        self.isTouchEnabled = YES;
	}
    
    [self scheduleUpdate];
	return self;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self genBackground];
}

-(void)update:(ccTime)dt{
    float PIXEL_PER_SECOND = 100;
    
    NSLog(@"ccTime");
    
    static float offset = 0;
    offset += PIXEL_PER_SECOND * dt;
    CGSize textureSize = _backgroud.textureRect.size;
    [_backgroud setTextureRect:CGRectMake(offset, 0, textureSize.width, textureSize.height)];
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
