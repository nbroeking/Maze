//
//  Person.h
//  HW6
//
//  Created by Nicolas Charles Herbert Broeking on 2/24/14.
//  Copyright (c) 2014 NicolasBroeking. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property double locx;
@property double locy;
@property double locz;
@property double lookx;
@property double looky;
@property double lookz;

@property bool moved;
@property(nonatomic) float theta;
@property (nonatomic) float phi;

-(void) update;
-(void) setPhit:(float)phit;
-(void) setThetat:(float)thetat;

-(bool) Winning;
-(void) reset;

@end
