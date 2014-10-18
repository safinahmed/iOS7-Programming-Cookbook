//
//  chapter11ViewController.m
//  Portfolio
//
//  Created by Safin Ahmed on 26/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import "chapter11ViewController.h"
#import <Social/Social.h>
#import "XMLElement.h"

@interface chapter11ViewController () <NSXMLParserDelegate>

@property (nonatomic, strong) NSXMLParser *xmlParser;
@property (nonatomic, strong) XMLElement *rootElement;
@property (nonatomic, strong) XMLElement *currentElementPointer;

@end

@implementation chapter11ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"DidStartDocument");
    self.rootElement = nil;
    self.currentElementPointer = nil;
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
attributes:(NSDictionary *)attributeDict
{
    NSLog(@"DidStartElement");
    if (self.rootElement == nil)
    {
        /* We don't have a root element. Create it and point to it */
        self.rootElement = [[XMLElement alloc] init];
        self.currentElementPointer = self.rootElement;
    }
    else
    {
        /* Already have root. Create new element and add it as one of
         the subelements of the current element */
        XMLElement *newElement = [[XMLElement alloc] init];
        newElement.parent = self.currentElementPointer;
        [self.currentElementPointer.subElements addObject:newElement];
        self.currentElementPointer = newElement;
    }
    self.currentElementPointer.name = elementName;
    self.currentElementPointer.attributes = attributeDict;
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSLog(@"FoundChars");
    if ([self.currentElementPointer.text length] > 0)
    {
        self.currentElementPointer.text = [self.currentElementPointer.text stringByAppendingString:string];
    }
    else
    {
        self.currentElementPointer.text = string;
    }
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
{
    NSLog(@"DidEndElement");
    self.currentElementPointer = self.currentElementPointer.parent;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"DidEndDocument");
    self.currentElementPointer = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //PARSE XML (NEED DELEGATE)
    NSString *xmlFilePath = [[NSBundle mainBundle] pathForResource:@"MyXML"
                                                            ofType:@"xml"];
    NSData *xml = [[NSData alloc] initWithContentsOfFile:xmlFilePath];
    self.xmlParser = [[NSXMLParser alloc] initWithData:xml];
    self.xmlParser.delegate = self;
    if ([self.xmlParser parse])
    {
        NSLog(@"The XML is parsed.");
        /* self.rootElement is now the root element in the XML */
        XMLElement *element = self.rootElement.subElements[1];
        NSLog(@"%@", element.subElements);
    }
    else
    {
            NSLog(@"Failed to parse the XML");
    }
    
    //SOCIAL SHARING
//    NSLog(@"FB %hhd, Twitter %hhd, Tencent Weibo %hhd, Weibo %hhd",
//          [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook],
//          [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter],
//          [SLComposeViewController isAvailableForServiceType:SLServiceTypeTencentWeibo],
//          [SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]);
//    
//    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
//        SLComposeViewController *controller =
//        [SLComposeViewController
//         composeViewControllerForServiceType:SLServiceTypeTwitter];
//        [controller setInitialText:@"MacBook Airs are amazingly thin!"];
//        [controller addImage:[UIImage imageNamed:@"MacBookAir"]];
//        [controller addURL:[NSURL URLWithString:@"http://www.apple.com/"]];
//        controller.completionHandler = ^(SLComposeViewControllerResult result){
//            NSLog(@"Completed %d",result);
//        };
//        [self presentViewController:controller animated:YES completion:nil];
//    }else{
//        NSLog(@"The twitter service is not available");
//    }
    
    
    
    //SERIALIZING / DESERIALIZING JSON
//    NSDictionary *dictionary =
//    @{
//      @"First Name" : @"Anthony",
//      @"Last Name" : @"Robbins",
//      @"Age" : @51,
//      @"children" : @[
//              @"Anthony's Son 1",
//              @"Anthony's Daughter 1",
//              @"Anthony's Son 2",
//              @"Anthony's Son 3",
//              @"Anthony's Daughter 2"
//              ],
//      };
//    
//    NSError *error = nil;
//    NSData *jsonData = [NSJSONSerialization
//                        dataWithJSONObject:dictionary
//                        options:NSJSONWritingPrettyPrinted
//                        error:&error];
//    if ([jsonData length] > 0 && error == nil)
//    {
//        NSLog(@"Successfully serialized the dictionary into data.");
//        NSString *jsonString =
//        [[NSString alloc] initWithData:jsonData
//                              encoding:NSUTF8StringEncoding];
//        NSLog(@"JSON String = %@", jsonString);
//        
//        /* Now try to deserialize the JSON object into a dictionary */
//        error = nil;
//        id jsonObject = [NSJSONSerialization
//                         JSONObjectWithData:jsonData
//                         options:NSJSONReadingAllowFragments
//                         error:&error];
//        if (jsonObject != nil && error == nil)
//        {
//            NSLog(@"Successfully deserialized...");
//            if ([jsonObject isKindOfClass:[NSDictionary class]])
//            {
//                NSDictionary *deserializedDictionary = jsonObject;
//                NSLog(@"Deserialized JSON Dictionary = %@ %@",
//                      deserializedDictionary,deserializedDictionary[@"children"][0]);
//                
//            }
//            else if ([jsonObject isKindOfClass:[NSArray class]])
//            {
//                NSArray *deserializedArray = (NSArray *)jsonObject;
//                NSLog(@"Deserialized JSON Array = %@", deserializedArray);
//            }
//            else {
//                /* Some other object was returned. We don't know how to
//                 deal with this situation as the deserializer only
//                 returns dictionaries or arrays */
//            }
//        }
//        else if (error != nil){
//            NSLog(@"An error happened while deserializing the JSON data.");
//        }
//    }
//    else if ([jsonData length] == 0 && error == nil){
//        NSLog(@"No data was returned after serialization.");
//    }
//    else if (error != nil){
//        NSLog(@"An error happened = %@", error);
//    }

    
    
    //PUT WITH MUTABLE URL REQUEST
//    NSString *urlAsString = @"www.google.com";
//    urlAsString = [urlAsString stringByAppendingString:@"?param1=First"];
//    urlAsString = [urlAsString stringByAppendingString:@"&param2=Second"];
//    NSURL *url = [NSURL URLWithString:urlAsString];
//    NSMutableURLRequest *urlRequest =
//    [NSMutableURLRequest requestWithURL:url];
//    [urlRequest setTimeoutInterval:30.0f];
//    [urlRequest setHTTPMethod:@"PUT"];
//    NSString *body = @"bodyParam1=BodyValue1&bodyParam2=BodyValue2";
//    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [NSURLConnection
//     sendAsynchronousRequest:urlRequest
//     queue:queue
//     completionHandler:^(NSURLResponse *response,
//                         NSData *data,
//                         NSError *error) {
//         if ([data length] >0 && error == nil)
//         {
//             NSString *html =
//             [[NSString alloc] initWithData:data
//                                   encoding:NSUTF8StringEncoding];
//             NSLog(@"HTML = %@", html);
//         }
//         else if ([data length] == 0 && error == nil)
//         {
//             NSLog(@"Nothing was downloaded.");
//         }
//         else if (error != nil)
//         {
//             NSLog(@"Error happened = %@", error);
//         }
//     }];
    
    
    //DELETE WITH MUTABLE URL REQUEST
//    NSString *urlAsString = @"www.google.com";
//    urlAsString = [urlAsString stringByAppendingString:@"?param1=First"];
//    urlAsString = [urlAsString stringByAppendingString:@"&param2=Second"];
//    NSURL *url = [NSURL URLWithString:urlAsString];
//    NSMutableURLRequest *urlRequest =
//    [NSMutableURLRequest requestWithURL:url];
//    [urlRequest setTimeoutInterval:30.0f];
//    [urlRequest setHTTPMethod:@"DELETE"];
//    NSString *body = @"bodyParam1=BodyValue1&bodyParam2=BodyValue2";
//    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [NSURLConnection
//     sendAsynchronousRequest:urlRequest
//     queue:queue
//     completionHandler:^(NSURLResponse *response,
//                         NSData *data,
//                         NSError *error) {
//         if ([data length] >0 && error == nil)
//         {
//             NSString *html =
//             [[NSString alloc] initWithData:data
//                                   encoding:NSUTF8StringEncoding];
//             NSLog(@"HTML = %@", html);
//         }
//         else if ([data length] == 0 && error == nil)
//         {
//             NSLog(@"Nothing was downloaded.");
//         }
//         else if (error != nil)
//         {
//             NSLog(@"Error happened = %@", error);
//         }
//     }];
    
    //POST WITH MUTABLE URL REQUEST
//    NSString *urlAsString = @"www.google.com";
//    urlAsString = [urlAsString stringByAppendingString:@"?param1=First"];
//    urlAsString = [urlAsString stringByAppendingString:@"&param2=Second"];
//    NSURL *url = [NSURL URLWithString:urlAsString];
//    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
//    [urlRequest setTimeoutInterval:30.0f];
//    [urlRequest setHTTPMethod:@"POST"];
//    NSString *body = @"bodyParam1=BodyValue1&bodyParam2=BodyValue2";
//    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [NSURLConnection
//     sendAsynchronousRequest:urlRequest
//     queue:queue
//     completionHandler:^(NSURLResponse *response,
//                         NSData *data,
//                         NSError *error) {
//         if ([data length] >0 && error == nil)
//         {
//             NSString *html =
//             [[NSString alloc] initWithData:data
//                                   encoding:NSUTF8StringEncoding];
//             NSLog(@"HTML = %@", html);
//         }
//         else if ([data length] == 0 && error == nil)
//         {
//             NSLog(@"Nothing was downloaded.");
//         }
//         else if (error != nil)
//         {
//             NSLog(@"Error happened = %@", error);
//         }
//     }];
    
    //GET WITH MUTABLE URL REQUEST
//    NSString *urlAsString = @"http://en.wikipedia.org/w/index.php";
//    urlAsString = [urlAsString stringByAppendingString:@"?title=Main_page"];
//    urlAsString = [urlAsString stringByAppendingString:@"&action=raw"];
//    NSURL *url = [NSURL URLWithString:urlAsString];
//    NSMutableURLRequest *urlRequest =
//    [NSMutableURLRequest requestWithURL:url];
//    [urlRequest setTimeoutInterval:30.0f];
//    [urlRequest setHTTPMethod:@"GET"];
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [NSURLConnection
//     sendAsynchronousRequest:urlRequest
//     queue:queue
//     completionHandler:^(NSURLResponse *response,
//                         NSData *data,
//                         NSError *error) {
//         if ([data length] >0 && error == nil)
//         {
//             NSString *html =
//             [[NSString alloc] initWithData:data
//                                   encoding:NSUTF8StringEncoding];
//             NSLog(@"HTML = %@", html);
//         }
//         else if ([data length] == 0 && error == nil)
//         {
//             NSLog(@"Nothing was downloaded.");
//         }
//         else if (error != nil){
//             NSLog(@"Error happened = %@", error);
//         }
//     }];
    
    
    
    //SYNC URL DOWNLOAD WITH QUEUE
//    NSLog(@"We are here...");
//    NSString *urlAsString = @"http://www.yahoo.com";
//    NSLog(@"Firing synchronous url connection...");
//    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(dispatchQueue, ^(void) {
//        NSURL *url = [NSURL URLWithString:urlAsString];
//        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//        NSURLResponse *response = nil;
//        NSError *error = nil;
//        NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest
//                                             returningResponse:&response
//                                             error:&error];
//        
//        if ([data length] > 0 && error == nil)
//        {
//                NSLog(@"%lu bytes of data was returned.",(unsigned long)[data length]);
//        }
//        else if ([data length] == 0 && error == nil)
//        {
//                NSLog(@"No data was returned.");
//        }
//        else if (error != nil)
//        {
//                NSLog(@"Error happened = %@", error);
//        }
//    });
//    NSLog(@"We are done.");
    
    
    
    //SYNC URL DOWNLOAD
//    NSLog(@"We are here...");
//    NSString *urlAsString = @"http://www.yahoo.com";
//    NSURL *url = [NSURL URLWithString:urlAsString];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//    NSURLResponse *response = nil;
//    NSError *error = nil;
//    NSLog(@"Firing synchronous url connection...");
//    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest
//                                         returningResponse:&response
//                                                     error:&error];
//    if ([data length] > 0 && error == nil)
//    {
//        NSLog(@"%lu bytes of data was returned.",(unsigned long)[data length]);
//    }
//    else if ([data length] == 0 && error == nil){
//        NSLog(@"No data was returned.");
//    }
//    else if (error != nil){
//        NSLog(@"Error happened = %@", error);
//    }
//    NSLog(@"We are done.");
//                                                  
    
    
    
    //ASYNC URL DOWNLOAD
//    NSString *urlAsString = @"http://www.apple.com";
//    NSURL *url = [NSURL URLWithString:urlAsString];
//    
////    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//    
//    NSURLRequest *urlRequest =
//    [NSURLRequest
//     requestWithURL:url
//     cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
//     timeoutInterval:3.0f];
//    
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [NSURLConnection
//     sendAsynchronousRequest:urlRequest
//     queue:queue
//     completionHandler:^(NSURLResponse *response,
//                         NSData *data,
//                         NSError *error) {
//         if ([data length] >0 && error == nil){
//             NSString *html = [[NSString alloc] initWithData:data
//                                                    encoding:NSUTF8StringEncoding];
//             NSLog(@"HTML = %@", html);
//         }
//         else if ([data length] == 0 && error == nil){
//             NSLog(@"Nothing was downloaded.");
//         }
//         else if (error != nil){
//             NSLog(@"Error happened = %@", error);
//         }
//     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
