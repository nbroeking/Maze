//
//  ViewController.m
//  Maze
//
//  Created by Nicolas Charles Herbert Broeking on 3/21/14.
//  Copyright (c) 2014 NicolasBroeking. All rights reserved.
//

#import "ViewController.h"
#import "World.h"
#import "Water.h"
#import "Ground.h"
#import "DrawableObject.h"
#import "Ocean.h"
#import "Winning.h"
#import "House.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@interface ViewController () {

    bool viewChanged;

}
@property (strong, nonatomic) EAGLContext *context;

- (void)setupGL;
- (void)tearDownGL;

@end

@implementation ViewController
@synthesize drawableObjects;
@synthesize person;
@synthesize won;
@synthesize playing;
@synthesize playButton;
@synthesize Menu;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    playing = false;
    
    won = false;
    
    viewChanged = false;
    
    self.time = 0;
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context)
    {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
}

- (void)dealloc
{
    NSLog(@"Deallocating the ViewController");
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context)
    {
        [EAGLContext setCurrentContext:nil];
    }
   /* if( drawableObjects != nil)
    {
        drawableObjects = nil;
    }*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
    
    if( drawableObjects != nil)
    {
        drawableObjects = nil;
    }
    
    // Dispose of any resources that can be recreated.
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    drawableObjects = [[NSMutableArray alloc]init];
    person = [[Person alloc] init];
    
    glEnable(GL_DEPTH_TEST);
    
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    GLKMatrix4 viewMatrix = GLKMatrix4MakeLookAt([person locx], [person locy], [person locz], [person lookx], [person looky], [person lookz], 0, 1, 0);
    
    //Create and add the world to the drawable object

    [drawableObjects addObject:[[World alloc] init]];
    [drawableObjects addObject:[[Ground alloc] init]];
    [drawableObjects addObject:[[Ocean alloc] init]];
    [drawableObjects addObject:[[House alloc] init]];
    [drawableObjects addObject:[[Winning alloc] init]];
    [drawableObjects addObject:[[Water alloc] init]];
    
    
    for( int i = 0; i < [drawableObjects count]; i++)
    {
        DrawableObject *temp = [drawableObjects objectAtIndex:i];
        
        [temp setProjectionMatrix:projectionMatrix];
        [temp setViewMatrix:viewMatrix];
        [temp update];
    }
    
    NSLog(@"Done With Initilization");
    NSLog(@"There are %lu objects",(unsigned long)[drawableObjects count]);
    //Set up the view
    
    
}

- (void)tearDownGL
{
    NSLog(@"Deallocate the view controller");
    [drawableObjects removeAllObjects];
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    self.time += self.timeSinceLastUpdate;
    if( [person moved])
    {
        double Ex = sin(3.1415927/180*[person theta])*cos(3.1415927/180*[person phi]);
        double Ez = cos(3.1415927/180*[person theta])*cos(3.1415927/180*[person phi]);
        double Ey = sin( [person phi]*3.1415927/180);
        
        [person setLocx:[person locx]+ Ex*10*self.timeSinceLastUpdate];
        [person setLocz:[person locz] + Ez*10*self.timeSinceLastUpdate];
        [person setLocy:[person locy] + Ey*10*self.timeSinceLastUpdate];
        [person update];
    }

    //if( viewChanged)
    //{
        //Calculate View Matrix
        
        float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
        GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 1.0f, 500.0f);
        GLKMatrix4 viewMatrix = GLKMatrix4MakeLookAt([person locx], [person locy], [person locz], [person lookx], [person looky], [person lookz], 0, 1, 0);
    
        for( int i = 0; i < [drawableObjects count]; i++)
        {
            [(DrawableObject*)[drawableObjects objectAtIndex:i] setTime:self.time];
            [(DrawableObject*)[drawableObjects objectAtIndex:i] setMatries:projectionMatrix:viewMatrix];
            [(DrawableObject*)[drawableObjects objectAtIndex:i] setLocation:GLKVector3Make([person locx], [person locy], [person locz])];
            [(DrawableObject*)[drawableObjects objectAtIndex:i] update];
        }
   // }
    
    if( [person Winning])
    {
        [self reset];
    }
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //NSLog(@"%d is the amount of objects!", [drawableObjects count]);
    for( int i = 0; i < [drawableObjects count]; i++)
    {
        [(DrawableObject*)[drawableObjects objectAtIndex:i] draw];
    }
    
    //NSLog(@"x = %f, y = %f, z = %f", [person locx],[person locy],[person locz]);
    
   /* int error = glGetError();
    if( error)
    {
        NSLog(@"OpenGl Error = %u", error);
    }*/
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if( playing)
    {
        //NSLog(@"Touches Began with %d presses!",[[[event allTouches] allObjects] count]);
        if( [[[event allTouches] allObjects] count] == 1)
        {
            [person setMoved:true]; //Should be true
        }
        else
        {
            [person setMoved:false]; //Should be false
        }
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if( playing)
    {
        [super touchesEnded:touches withEvent:event];
    
    //NSLog(@"Number of fingers %d",[[[event allTouches] allObjects] count]);
    
        [person setMoved:false];
    }
    //NSLog(@"Ended");
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    if( playing)
    {
        NSArray *touche = [[event allTouches] allObjects];
    
        CGPoint point = [[touche objectAtIndex:0] locationInView:self.view];
        CGPoint oldpoint = [[touche objectAtIndex:0] previousLocationInView:self.view];
    
        float dx = point.x - oldpoint.x;
        float dy = point.y - oldpoint.y;
    
        //NSLog(@"%f %f", point.x, point.y);
        [person setThetat:[person theta] + dx/3];
        [person setPhit:[person phi] + dy/3];
    
    }
    //NSLog(@"Moved");

}
- (IBAction)play:(id)sender
{
    
    playing = true;
    
    [UIView animateWithDuration:1.0f animations:^{
        Menu.hidden = true;
        playButton.hidden = true;
    }];
    
}
-(void)reset
{
    Menu.text = @"You Won!!";
    [playButton setTitle:@"Play Again?" forState:UIControlStateNormal];

    
    playing = false;
    
    [person reset];
    [UIView animateWithDuration:1.0f animations:^{
        Menu.hidden = false;
        playButton.hidden = false;
    }];
}
@end
