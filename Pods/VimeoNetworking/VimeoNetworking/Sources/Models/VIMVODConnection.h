//
//  VIMVODConnection.h
//  Pods
//
//  Created by Guhit, Fiel on 3/9/17.
//
//

#import <VimeoNetworking/VimeoNetworking.h>

@interface VIMVODConnection : VIMConnection

@property (nonatomic, strong, nullable) NSNumber *extraVideosCount;
@property (nonatomic, strong, nullable) NSNumber *mainVideosCount;
@property (nonatomic, strong, nullable) NSNumber *viewableVideosCount;

@end
