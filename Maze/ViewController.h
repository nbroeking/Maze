//
//  ViewController.h
//  Maze
//
//  Created by Nicolas Charles Herbert Broeking on 3/21/14.
//  Copyright (c) 2014 NicolasBroeking. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#import "Person.h"

@interface ViewController : GLKViewController

@property (strong, nonatomic) IBOutlet UILabel *Menu;
@property (strong, nonatomic) NSMutableArray *drawableObjects;
@property (strong, nonatomic) Person *person;
@property double time;
@property (strong, nonatomic) IBOutlet UIButton *playButton;

@property bool playing;

@property bool won;

- (IBAction)play:(id)sender;
@end
