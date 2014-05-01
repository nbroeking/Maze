//
//  Person.m
//  HW6
//
//  Created by Nicolas Charles Herbert Broeking on 2/24/14.
//  Copyright (c) 2014 NicolasBroeking. All rights reserved.
//

#import "Person.h"

@implementation Person
{
    float deg;
}
@synthesize locx, locy, locz, moved, theta, phi, lookx, looky, lookz;

-(id)init
{
    if(self = [super init])
    {
        locx = 0;
        locz = 40;
        locy = 20;
        moved = false;
        theta = 0;
        phi = 0;
        deg = 3.1415927/180;
        
        [self update];
    }
    return self;
}

-(void)update
{
    lookx = locx + sin(deg*theta)*cos(deg*phi);
    looky = locy + sin(deg*phi);
    lookz = locz + cos(deg*theta)*cos(deg*phi);
}
-(void)setPhit:(float)phit
{
    if( (phit < 89)&&(phit > -89))
    {
        phi = phit;
        [self update];
    }
}
-(void)setThetat:(float)thetat
{
    if( (thetat < 360))
    {
        theta = thetat - 360;
        [self update];
    }
    else if( (thetat >= 0))
    {
        theta = thetat + 0;
        [self update];
    }
}
-(void)reset
{
    locx = 0;
    locz = 40;
    locy = 20;
    moved = false;
    theta = 0;
    phi = 0;
    deg = 3.1415927/180;
    
    [self update];
}
-(bool) Winning
{
    if( (locx < -40)&&(locx > -50 )&&(locy < 15)&&(locy > 5)&&( locz < -55)&&(locz > -65))
    {
        return true;
    }
    return false;
}
@end
