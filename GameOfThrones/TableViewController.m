//
//  TableViewController.m
//  GameOfThrones
//
//  Created by Chucky on 3/29/16.
//  Copyright © 2016 Chuck. All rights reserved.
//

/*
 bran-200x450.jpg
 catelyn-200x450.jpg
 cersei-200x450.jpg
 jaime-200x450.jpg
 joffrey-200x450.jpg
 jon-snow-200x450.jpg
 ned-200x450.jpg
 robb-200x450.jpg
 robert-200x450.jpg
 tyrion-200x450.jpg
 
 Arryn.png
 Baratheon.png
 Greyjoy.png
 Lannister.png
 Martell.png
 Stark.png
 Targaryen.png
 Tully.png
 Tyrell.png
 */


#import "TableViewController.h"
#import "CustomTableViewCell.h"
#import "Character.h"
#import "AppDelegate.h"


@interface TableViewController ()


@property NSMutableArray *characterArray;
@property NSArray *characterName;
@property NSArray *characterHouse;
@property NSArray *characterAge;
@property NSArray *characterActor;
@property NSArray *characterGender;

@property NSArray *characterImage;
@property NSArray *houseImage;

@property NSManagedObjectContext *moc;



@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.characterArray = [[NSMutableArray alloc]init];
    
    self.characterName = @[@"Bran",@"Catelyn",@"Cersei"];
    self.characterHouse = @[@"Arryn",@"Baratheon",@"Greyjoy"];
    self.characterAge = @[@20, @30, @30];
    self.characterActor = @[@"actor 1", @"actor 2", @"actor 3"];
    self.characterGender = @[@"m",@"f",@"f"];
    
    
    self.characterImage = @[@"bran-200x450.jpg",@"catelyn-200x450.jpg",@"cersei-200x450.jpg"];
    self.houseImage = @[@"Arryn.png",@"Baratheon.png",@"Greyjoy.png"];
    
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.moc = appDelegate.managedObjectContext;
    
    
    if (![self coreDataHasEntriesForEntityName]) {
        for (int i = 0; i < 3; i++) {
            Character *character = [NSEntityDescription insertNewObjectForEntityForName:@"CharacterEntity" inManagedObjectContext:self.moc];
            
            //Character *character = [Character new];
            character.name = self.characterName[i];
            character.house = self.characterHouse[i];
            character.age = self.characterAge[i];
            character.gender = self.characterGender[i];
            
            UIImage *characterImage = [UIImage imageNamed:self.characterImage[i]];
            NSData *characterImageData = UIImageJPEGRepresentation(characterImage, 0.7);
            character.imageCharacter =characterImageData;
            
            UIImage *houseImage = [UIImage imageNamed:self.houseImage[i]];
            NSData *houseImageData = UIImageJPEGRepresentation(houseImage, 0.7);
            character.imageHouse =houseImageData;
            
            [self.characterArray addObject:character];
        }
    }

    
    
    NSError *error;
    if ([self.moc save:&error]) {
        [self.tableView reloadData];
    } else {
        NSLog(@"error has occurred: %@",error);
    }
    
    [self loadCharacters];
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.characterArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    
    Character *character = [self.characterArray objectAtIndex:indexPath.row];
    cell.image1.image = [UIImage imageWithData:[character imageCharacter]];
    cell.image2.image = [UIImage imageWithData:[character imageHouse]];
    cell.label.text = character.name;
    
    return cell;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadCharacters];
    [self.tableView reloadData];
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Delete"
                                                                                 message:@"Are you sure?"
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *deleteButton = [UIAlertAction actionWithTitle:@"Delete"
                                                               style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 [self.moc deleteObject:[self.characterArray objectAtIndex:indexPath.row]];
                                                                 NSError *error;
                                                                 if ([self.moc save:&error]) {
                                                                     [self.characterArray removeObjectAtIndex:indexPath.row];
                                                                     [self.tableView reloadData];
                                                                 } else {
                                                                     NSLog(@"error has occurred: %@",error);
                                                                 }
                                                                 
                                                             }];
        
        
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        
        [alertController addAction:deleteButton];
        [alertController addAction:cancelButton];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NSString stringWithFormat:@"Die %@!",[[self.characterArray objectAtIndex:indexPath.row] name]];

}

- (IBAction)onEditButtonPressed:(UIBarButtonItem *)sender {
    self.editing = !self.editing;
    if (self.editing) {
        sender.title = @"Done";
        [self.tableView setEditing:true animated:true];
    } else {
        sender.title = @"Edit";
        [self.tableView setEditing:false animated:true];
    }
    
}


-(void)loadCharacters
{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"CharacterEntity"];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:false];
    request.sortDescriptors = @[sortByName];
    
    //NSPredicate *predicate= [NSPredicate predicateWithFormat:@"age>=30"];
    //request.predicate = predicate;
    
    NSError *error;
    self.characterArray = [[self.moc executeFetchRequest:request error:&error] mutableCopy];
    if (error == nil)
    {
        [self.tableView reloadData];
    } else {
        NSLog(@"Error: %@",error);
    }
}



- (BOOL)coreDataHasEntriesForEntityName {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CharacterEntity" inManagedObjectContext:self.moc];
    [request setEntity:entity];
    [request setFetchLimit:1];
    NSError *error = nil;
    NSArray *results = [self.moc executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Fetch error: %@", error);
        abort();
    }
    if ([results count] == 0) {
        return NO;
    }
    return YES;
}


@end
