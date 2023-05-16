//
//  Dog.m
//  objectivec-smile-han
//
//  Created by JeongminKim on 2023/05/16.
//

#import "Dog.h"
@implementation Dog
-(void)setAge:(int)a
{
    age = a;
}
-(int)getAge
{
    return age;
}
-(void)show
{
    NSLog(@"%d\n",age);
}
@end
