//
//  MyScene.m
//  DelaunayTriangulation_SpriteKit_tutorial
//
//  Created by Sam  keene on 3/01/14.
//  Copyright (c) 2014 Sam  keene. All rights reserved.
//

#import "MyScene.h"
#import "DelaunayVoronoi.h"
#import "DelaunayEdge.h"
#import "DelaunayVertex.h"
#import "DelaunayLineSegment.h"

#define kMaxNumPoints 30

@interface MyScene ()
@property (nonatomic, strong) SKTexture *trianglesTexture;
@property (nonatomic, strong) SKNode *canvasNode;
@property (nonatomic, strong) DelaunayVoronoi *delaunayVoronoi;
@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
       
    }
    return self;
}

- (void)setupTriangles
{
    self.canvasNode = [SKNode node];
    
    [self redrawTriangles];
}

- (void)redrawTriangles
{
    
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    self.delaunayVoronoi = [DelaunayVoronoi voronoiWithPoints:[self randomPointsWithLength:kMaxNumPoints] plotBounds:rect];
    
    [self removeAllChildren];
    
    for (DelaunayEdge *e in self.delaunayVoronoi.edges) {
        SKShapeNode *line = [SKShapeNode node];
        line.path = [self linePathWithStartPoint:e.delaunayLine.p0 andEndPoint:e.delaunayLine.p1];
        line.lineWidth = .5;
        [line setStrokeColor:[UIColor whiteColor]];
        [self addChild:line];
    }
}

// generate random points for the verticies of the triangles
- (NSArray *)randomPointsWithLength:(NSInteger)length
{
    NSMutableArray *pointsArray = [NSMutableArray array];
    
    for (int i = 0; i < length; i++) {
        CGPoint point1 = CGPointMake(arc4random_uniform(self.frame.size.width), arc4random_uniform(self.frame.size.height));
        NSValue *value = [NSValue valueWithCGPoint:point1];
        [pointsArray addObject:value];
    }

    return pointsArray;

}

- (CGPathRef)linePathWithStartPoint:(CGPoint)p0 andEndPoint:(CGPoint)p1
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, p0.x, p0.y);
    CGPathAddLineToPoint(path, NULL, p1.x, p1.y);
    
    return path;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
     [self redrawTriangles];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
