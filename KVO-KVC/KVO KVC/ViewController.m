//
//  ViewController.m
//  KVO KVC Demo
//
//  Created by Paul Solt on 4/9/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

#import "ViewController.h"
#import "LSIDepartment.h"
#import "LSIEmployee.h"
#import "LSIHRController.h"


@interface ViewController ()

@property (nonatomic) LSIHRController *hrController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    LSIDepartment *marketing = [[LSIDepartment alloc] init];
    marketing.name = @"Marketing";
    LSIEmployee * philSchiller = [[LSIEmployee alloc] init];
    philSchiller.name = @"Phil";
    philSchiller.jobTitle = @"VP of Marketing";
    philSchiller.salary = 10000000;
    marketing.manager = philSchiller;
    
    
    LSIDepartment *engineering = [[LSIDepartment alloc] init];
    engineering.name = @"Engineering";
    LSIEmployee *craig = [[LSIEmployee alloc] init];
    craig.name = @"Craig";
    craig.salary = 9000000;
    craig.jobTitle = @"Head of Software";
    engineering.manager = craig;
    
    LSIEmployee *e1 = [[LSIEmployee alloc] init];
    e1.name = @"Chad";
    e1.jobTitle = @"Engineer";
    e1.salary = 200000;
    
    LSIEmployee *e2 = [[LSIEmployee alloc] init];
    e2.name = @"Lance";
    e2.jobTitle = @"Engineer";
    e2.salary = 250000;
    
    LSIEmployee *e3 = [[LSIEmployee alloc] init];
    e3.name = @"Joe";
    e3.jobTitle = @"Marketing Designer";
    e3.salary = 100000;
    
    [engineering addEmployee:e1];
    [engineering addEmployee:e2];
    [marketing addEmployee:e3];
    
    LSIHRController *controller = [[LSIHRController alloc] init];
    [controller addDepartment:engineering];
    [controller addDepartment:marketing];
    self.hrController = controller;
    
    //    NSLog(@"%@", self.hrController);
    
    // Key Value Coding: KVC
    
    // * Core Data
    // * Cocoa Bindings (UI + Model = SwiftUI)
    
    // @property NSString *name;  // Properties are automatically KVC
    
    // 1. Accessor for a property
    // - (NSString *)name;
    // 2. Setter for a property
    // - (void)setName:(NSString *)name
    // 3. Instance variable to set
    
    // Modify our Data using the self.name syntax (not _name)
    
    // 1. init/dealloc always use: _name =
    // 2. Normal methods always use: self.name =
    
    // Property accessor (method call or the property dot syntax)
    NSString *name = [craig name];
    NSLog(@"Name: %@", name);
    
    //Dynamic method call - look up methods and call them via a NSString name
    //    NSString *name2 = [craig valueForKey:@"name"];
    //    NSString *name2 = [craig valueForKey:@"firstName"]; // No build issues, CRASHES at runtime!
    NSString *name2 = [craig valueForKey:@"privateName"]; // No build issues, accesses a private property
    NSLog(@"Name2: %@", name2);
    
    [craig setValue:@"Bob" forKey:@"name"];
    NSLog(@"Name Change: %@", craig.name);
    
    // 1. Spelling is vert important when using keys (Crash at runtime)
    // 2. Types must match or it'll crash
    
    [craig setValue:@42 forKey:@"name"]; // Converted NSNumber to NSString and set it
    NSLog(@"Name Change: %@", craig.name);
    
    // "age" : "42"
    
    // Collections and Keypaths
    
    NSLog(@"Departments; %@", [[self hrController] departments]); // method calling
    NSLog(@"Departments; %@", self.hrController.departments); // dot syntax
    
    ///
    // keypath: departments
//    NSLog(@"Departments3: %@", [self.hrController valueForKeyPath:@"departments"]); // dot syntax
//
//    NSLog(@"Department Name: %@", [self.hrController valueForKeyPath:@"departments.name"]);
//    NSLog(@"Department Employees: %@", [self.hrController valueForKeyPath:@"departments.employees"]);
    ///
    
    // keypath: departments
    NSLog(@"Departments3a: %@", [self.hrController valueForKeyPath:@"departments"]); // dot syntax
    NSLog(@"Departments3b: %@", [self.hrController valueForKey:@"departments"]); // dot syntax
    
    // Traversing the objects LSIHRController (departments) . LSIDepartment (name)
    NSLog(@"Department Name: %@", [self.hrController valueForKeyPath:@"departments.name"]);
    
    //    NSLog(@"Department Name: %@", [self.hrController valueForKey:@"departments.name"]); // CRASH! Not a property/method name
    
    // like a .map to aggregate all the department employee arrays into a big array of arrays
    // [[Employee]]
    
    NSLog(@"Department Employees: %@", [self.hrController valueForKeyPath:@"departments.employees"]);
    
    // Collection Operators
    
    // Goal: [Employee]
    // @"distinctUnionOfArrays = unique values
//    NSLog(@"Department Employees: %@", [self.hrController valueForKeyPath:@"departments.@distinctUnionOfArrays.employees"]);
    
    NSArray<LSIEmployee *> *allEmployees = [self.hrController valueForKeyPath:@"departments.@distinctUnionOfArrays.employees"];
    NSLog(@"Department Employees: %@", allEmployees);
    
    NSLog(@"Salaries: %@", [allEmployees valueForKeyPath:@"salary"]);
    NSLog(@"Salaries: %@", [allEmployees valueForKeyPath:@"@max.salary"]);
    
    // TODO: Print another collection operator on the allEmployees Array
    NSLog(@"Min Salary: %@", [allEmployees valueForKeyPath:@"@min.salary"]);
    NSLog(@"Count Employees: %@", [allEmployees valueForKeyPath:@"@count"]); // this works for count of employees
    
    // Count the nmber of employees
//    NSLog(@"Count employees: %@", [self.hrController valueForKeyPath:@"departments.@distinctUnionOfArrays.employees"]); // doesn't work

}


@end
