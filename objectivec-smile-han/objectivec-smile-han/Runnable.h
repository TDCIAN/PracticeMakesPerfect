//
//  Runnable.h
//  objectivec-smile-han
//
//  Created by JeongminKim on 2023/05/16.
//
#import <Foundation/Foundation.h>
@protocol Runnable <NSObject>
@required
-(void) run;
@optional
-(void) walk;
@end
