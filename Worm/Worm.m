

//
//  Worm.m
//  Worm
//
//  Created by Jusive on 15/12/1.
//  Copyright © 2015年 Jusive. All rights reserved.
//

#import "Worm.h"

@interface Worm()
@property (nonatomic,strong) NSArray *views;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@property (nonatomic, strong) UICollisionBehavior *collision;
@property (nonatomic, weak) UIView *headView;
@property (nonatomic, strong) UIAttachmentBehavior *attachment;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@end
@implementation Worm

-(NSArray *)views{
    if (_views == nil) {
        NSMutableArray * arrayM = [NSMutableArray array];
        int count = 9;
        for (int i = 0; i < count; i++) {
            UIView *view = [[UIView alloc]init];
            [self addSubview:view];
            [arrayM addObject:view];
        }
        _views = arrayM;
    }
    return _views;
}
-(UIDynamicAnimator *)animator{
    if (_animator == nil) {
        _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
    }
    return _animator;
}

-(void)layoutSubviews{
    CGFloat w =20;
    CGFloat h = w;
    CGFloat starY= 100;
    CGFloat starX =30;
    
    for (int i =0; i <self.views.count; i++) {
        
        CGFloat x = starX + w * i;
        
        UIView *view = self.views[i];
        if (i == self.views.count - 1) {
            
            starY = starY - h * 0.5;
            
            view.frame = CGRectMake(x, starY, w * 2, h * 2);
            view.backgroundColor = [UIColor greenColor];
            view.layer.cornerRadius = 20;
            view.layer.masksToBounds = YES;
            
            self.headView = view;
        }else{
            view.frame = CGRectMake(x, starY, w, h);
            view.backgroundColor = [UIColor blueColor];
            view.layer.cornerRadius =10;
            view.layer.masksToBounds = YES;
        }
        
    }
    //附着行为
    for (int i = 0; i < self.views.count - 1; i++) {
        UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:self.views[i] attachedToItem:self.views[i + 1]];
        
        [self.animator addBehavior:attachment];
    }
    if (_gravity == nil) {
        self.gravity = [[UIGravityBehavior alloc]initWithItems:self.views];
        [self.animator addBehavior:self.gravity];
    }
    if (_collision == nil) {
        self.collision = [[UICollisionBehavior alloc]initWithItems:self.views];
        self.collision.translatesReferenceBoundsIntoBoundary = YES;
        [self.animator addBehavior:self.collision];
    }
    if (_pan == nil) {
        self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        
        [self addGestureRecognizer:self.pan];
        
//        self.pan = pan;
    }
}
-(void)panAction:(UIPanGestureRecognizer *)recognizer{
    
    CGPoint loc = [recognizer locationInView:self];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc]initWithItem:self.headView attachedToAnchor:loc];
        attachment.length = 50;
        
        self.attachment = attachment;
        
        [self.animator addBehavior:attachment];
        
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        
        self.attachment.anchorPoint = loc;
    }else if (recognizer.state == UIGestureRecognizerStateEnded){
        
        [self.animator removeBehavior:self.attachment];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
