//
//  ViewController.m
//  OneHubOAuth
//
//  Created by Amit on 04/03/17.
//
//

#import "ViewController.h"

#define TOKEN_URL @"https://ws-api.onehub.com/oauth/token"
#define CLIENT_ID @"ENTER CLIENT ID HERE"
#define CLIENT_SECRET @"ENTER CLIENT SECRET HERE"
#define USERNAME @"ENTER USERNAME HERE"
#define PASSWORD @"ENTER PASSWORD HERE"
#define REDIRECT_URI @"https://localhost"
#define GRANT_TYPE @"password"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *param = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=%@&password=%@&username=%@", CLIENT_ID, CLIENT_SECRET, GRANT_TYPE, PASSWORD, USERNAME];
    
    [self getAccessTokenUrl:TOKEN_URL parameters:param completionHandler:^(NSDictionary *data, NSError *error){
        if (!error) {
            // Total response
            NSLog(@"RESPONSE: %@", data);
            
            // Use this token for other transactions
            NSLog(@"TOKEN: %@", [data objectForKey:@"access_token"]);
        }
        else{
            NSLog(@"ERROR: %@", [error description]);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Get Access Token
-(void) getAccessTokenUrl:(NSString *)requestUrl parameters:(NSString *)requestParameters completionHandler:(void(^)(NSDictionary *data, NSError *error)) completionBlock;
{
    // 1
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // 2
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    // 3
    NSError *err = nil;
    if(requestParameters != nil){
        [request setHTTPBody:[requestParameters dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (err == nil) {
        // 4
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            // Handle response here
            //NSLog(@"Got response %@ with error %@.\n", response, error);
            if (error == nil) {
                NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                //NSLog(@"%@", httpResp);
                // If the HTTP status code is 200 then all is well
                if (httpResp.statusCode == 200) {
                    NSError *jsonError;
                    NSDictionary *dicJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                    if (!jsonError) {
                        completionBlock (dicJSON, error);
                    }
                }
                else{
                    NSString *statusCode = [NSString stringWithFormat:@"%lu", httpResp.statusCode];
                    NSDictionary *errorDic = @{@"statusCode":statusCode, @"description":@"Bad request..", @"headers":[httpResp allHeaderFields]};
                    NSError *anError = [[NSError alloc] initWithDomain:NSOSStatusErrorDomain code:httpResp.statusCode userInfo:errorDic];
                    
                    completionBlock (nil, anError);
                }
            } else {
                completionBlock (nil, err);
            }
        }];
        // 5
        [dataTask resume];
    }
    else{
        completionBlock (nil, err);
    }
}

@end
