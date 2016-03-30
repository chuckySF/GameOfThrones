//
//  AddViewController.m
//  GameOfThrones
//
//  Created by Chucky on 3/29/16.
//  Copyright © 2016 Chuck. All rights reserved.
//

#import "AddViewController.h"
#import "Character.h"
#import "AppDelegate.h"


@interface AddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *houseTextField;
@property (weak, nonatomic) IBOutlet UITextField *actorTextField;

@property NSManagedObjectContext *moc2;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.moc2 = appDelegate.managedObjectContext;
}
- (IBAction)onDonePressed:(UIButton *)sender {
    Character *character = [NSEntityDescription insertNewObjectForEntityForName:@"CharacterEntity" inManagedObjectContext:self.moc2];
    character.name = self.nameTextField.text;
    character.age = @([self.ageTextField.text integerValue]);
    character.house = self.houseTextField.text;
    character.actor = self.actorTextField.text;
    
    UIImage *characterImage = [UIImage imageNamed:@"robert-200x450.jpg"];
    NSData *characterImageData = UIImageJPEGRepresentation(characterImage, 0.7);
    character.imageCharacter =characterImageData;
    
    UIImage *houseImage = [UIImage imageNamed:@"Martell"];
    NSData *houseImageData = UIImageJPEGRepresentation(houseImage, 0.7);
    character.imageHouse =houseImageData;
    
    NSError *error;
    if ([self.moc2 save:&error]) {
    } else {
        NSLog(@"error has occurred: %@",error);
    }
    
    self.nameTextField.text = nil;
    self.ageTextField.text = nil;
    self.houseTextField.text = nil;
    self.actorTextField.text = nil;
    
    [self.nameTextField resignFirstResponder];
    [self.ageTextField resignFirstResponder];
    [self.houseTextField resignFirstResponder];
    [self.actorTextField resignFirstResponder];
    
    NSLog(@"done adding");
}

- (IBAction)onMalePressed:(UIButton *)sender {
}

- (IBAction)onFemalePressed:(UIButton *)sender {
}




@end
