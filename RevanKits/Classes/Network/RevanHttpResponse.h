//
//  RevanHttpResponse.h
//  QMKit
//
//  Created by Revan on 2018/7/19.
//

#import <Foundation/Foundation.h>

@interface RevanHttpResponse : NSObject
@property (nonatomic, readonly) int code;
@property (nonatomic, readonly) NSString *message;
@property (nonatomic, readonly) id data;

@property (nonatomic, copy) NSString *originUrlString;

@property (nonatomic, strong, readonly) NSError *error;
@property (nonatomic, readonly) BOOL serverError;

@property (nonatomic, readonly, copy) NSString *errorDomain;

+ (instancetype)responseOfResponseObject:(id)aResponseObject;
+ (instancetype)responseOfError:(NSError *)aError;
+ (instancetype)responseOfNoNetwork;
+ (instancetype)responseOfEmptyUrl;
@end
