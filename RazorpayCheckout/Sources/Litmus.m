//
//  Litmus.m
//  
//
//  Created by Burhan on 07/05/24.
//

#import <Foundation/Foundation.h>
@interface Car : NSObject

// Properties (access to instance variables)
@property (nonatomic, strong) NSString *model;
@property (nonatomic) int year;

// Methods (actions the Car can perform)
- (void) drive;
- (NSString *)description;

@end
