//
//  RSAKeygen.c
//  Gigma
//
//  Created by Jake Chong on 09/06/2023.
//

#import "RSAManager.h"
#import "chilkatIOS/include/CkoRsa.h"
#import "MainViewController.h"

@interface RSAManager () {
    NSUserDefaults * userDefs;
}

@property (retain, nonatomic) CkoRsa * rsa;

@end

@implementation RSAManager

@synthesize rsa;
@synthesize publicKey;
@synthesize privateKey;

- (instancetype) init {
    self = [super init];
    
    self.rsa = [[CkoRsa alloc] init];
    BOOL success;
    
    userDefs = [NSUserDefaults standardUserDefaults];
    NSString * pubKey = [userDefs stringForKey: @"RSAPublicKey"];
    if (pubKey != nil) {
        publicKey = pubKey;
        NSLog(@"herererere: %@", pubKey);
        privateKey = [userDefs stringForKey: @"RSAPrivateKey"];
    }
    else {
        success = [rsa GenerateKey: @(PUB_KEY_SIZE)];
        if (success) {
            publicKey = [rsa ExportPublicKey];
            privateKey = [rsa ExportPrivateKey];
        }
        else {
            [rsa dispose];
            return nil;
        }
    }
    return self;
}

- (NSString *) name {
    return [userDefs stringForKey: @"RSAName"];
}

- (void) dealloc {
    if ([userDefs stringForKey: @"RSAPublicKey"] == nil) {
        [userDefs setObject: publicKey forKey: @"RSAPublicKey"];
        [userDefs setObject: privateKey forKey: @"RSAPrivateKey"];
    }
}

@end
