//
//  safView.m
//  Portfolio
//
//  Created by Safin Ahmed on 30/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import "safView.h"

@implementation safView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) enumerateFonts{
    for (NSString *familyName in [UIFont familyNames]){ NSLog(@"Font Family = %@", familyName);
        for (NSString *fontName in
             [UIFont fontNamesForFamilyName:familyName]){ NSLog(@"\t%@", fontName);
        } }
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
//    [self enumerateFonts];
}
    
- (void)drawRect:(CGRect)rect
{
    
    //WRITING TEXT
//    /* Load the color */
//    UIColor *magentaColor =[UIColor colorWithRed:0.5f
//                                           green:0.0f
//                                            blue:0.5f
//                                           alpha:1.0f];
//    /* Set the color in the graphical context */
//    [magentaColor set];
//    /* Load the font */
//    UIFont *helveticaBold = [UIFont fontWithName:@"HelveticaNeue-Bold"
//                                            size:30.0f];
//
//    /* Our string to be drawn */
//    NSString *myString = @"I Learn Really Fast";
//    /* Draw the string using the font. The color has
//     already been set */
////    [myString drawAtPoint:CGPointMake(25, 190)
////           withAttributes:@{
////                            NSFontAttributeName : helveticaBold
////                            }];
//    [myString drawWithRect:CGRectMake(100, /* x */
//                                      120, /* y */
//                                      100, /* width */
//                                      200)
//                   options:NSStringDrawingUsesLineFragmentOrigin
//                attributes:@{
//                             NSFontAttributeName : helveticaBold
//                             }
//                   context:nil];
    
    //SHOWING IMAGES
//    /* Assuming the image is in your app bundle and we can load it */
//    UIImage *xcodeIcon = [UIImage imageNamed:@"2"];
//    [xcodeIcon drawAtPoint:CGPointMake(0.0f,
//                                       120.0f)];
//    [xcodeIcon drawInRect:CGRectMake(50.0f,
//                                     110.0f,
//                                     40.0f,
//                                     35.0f)];
    
    //Drawing lines
////    /* Set the color that we want to use to draw the line */
////    [[UIColor brownColor] set];
////    /* Get the current graphics context */
////    CGContextRef currentContext = UIGraphicsGetCurrentContext();
////    /* Set the width for the line */
////    CGContextSetLineWidth(currentContext,
////                          5.0f);
////    /* Start the line at this point */
////    CGContextMoveToPoint(currentContext,
////                         50.0f,
////                         110.0f);
////    /* And end it at this point */
////    CGContextAddLineToPoint(currentContext,
////                            100.0f,
////                            300.0f);
////    
////    /* Extend the line to another point */
////    CGContextAddLineToPoint(currentContext,
////                            300.0f,
////                            100.0f);
////    
////    /* Use the context's current color to draw the line */
////    CGContextStrokePath(currentContext);
//    
//    
//    [self drawRooftopAtTopPointof:CGPointMake(160.0f, 40.0f)
//                    textToDisplay:@"Miter"
//                         lineJoin:kCGLineJoinMiter];
//    
//    [self drawRooftopAtTopPointof:CGPointMake(160.0f, 180.0f)
//                    textToDisplay:@"Bevel"
//                         lineJoin:kCGLineJoinBevel];
//    [self drawRooftopAtTopPointof:CGPointMake(160.0f, 320.0f)
//                    textToDisplay:@"Round"
//                         lineJoin:kCGLineJoinRound];
    
    
    //BUILDING PATHS
    
//    /* Create the path */
//    CGMutablePathRef path = CGPathCreateMutable();
//    /* How big is our screen? We want the X to cover the whole screen */
//    CGRect screenBounds = [[UIScreen mainScreen] bounds];
//    /* Start from top-left */
//    CGPathMoveToPoint(path,
//                      NULL,
//                      screenBounds.origin.x,
//                      screenBounds.origin.y);
//    /* Draw a line from top-left to bottom-right of the screen */
//    CGPathAddLineToPoint(path,
//                         NULL,
//                         screenBounds.size.width,
//                         screenBounds.size.height);
//    /* Start another line from top-right */
//    CGPathMoveToPoint(path,
//                      NULL,
//                      screenBounds.size.width,
//                      screenBounds.origin.y);
//    /* Draw a line from top-right to bottom-left */
//    CGPathAddLineToPoint(path,
//                         NULL,
//                         screenBounds.origin.x,
//                         screenBounds.size.height);
//    /* Get the context that the path has to be drawn on */
//    CGContextRef currentContext = UIGraphicsGetCurrentContext();
//    /* Add the path to the context so we can
//     draw it later */
//    CGContextAddPath(currentContext,
//                     path);
//    /* Set the blue color as the stroke color */
//    [[UIColor blueColor] setStroke];
//    /* Draw the path with stroke color */
//    CGContextDrawPath(currentContext,
//                      kCGPathStroke);
//    /* Finally release the path object */
//    CGPathRelease(path);
    
    
    //ADDING RECTANGLES
    
//    /* Create the path first. Just the path handle. */
//    CGMutablePathRef newPath = CGPathCreateMutable();
//    /* Here are our rectangle boundaries */
//    CGRect rectangle = CGRectMake(10.0f,
//                                  30.0f,
//                                  200.0f,
//                                  300.0f);
//    
////    CGRect rectangle2 = CGRectMake(40.0f,
////                                   100.0f,
////                                   90.0f,
////                                   300.0f);
////    /* Put both rectangles into an array */
////    CGRect rectangles[2] = {
////        rectangle, rectangle2
////    };
////    /* Add the rectangles to the path */
////    CGPathAddRects(path,
////                   NULL,
////                   (const CGRect *)&rectangles, 2);
//    
//    /* Add the rectangle to the path */
//    CGPathAddRect(newPath,
//                  NULL,
//                  rectangle);
////    /* Get the handle to the current context */
////    CGContextRef currentContext = UIGraphicsGetCurrentContext();
//    /* Add the path to the context */
//    CGContextAddPath(currentContext,
//                     newPath);
//    /* Set the fill color to cornflower blue */
//    [[UIColor colorWithRed:0.20f
//                     green:0.60f
//                      blue:0.80f
//                     alpha:1.0f] setFill];
//    /* Set the stroke color to brown */
//    [[UIColor brownColor] setStroke];
//    /* Set the line width (for the stroke) to 5 */
//    CGContextSetLineWidth(currentContext,
//                          5.0f);
//    /* Stroke and fill the path on the context */
//    CGContextDrawPath(currentContext,
//                      kCGPathFillStroke);
//    /* Dispose of the path */
//    CGPathRelease(newPath);
    
    
    
    //SHADOWS
//    [self drawRectAtTopOfScreen];
//    [self drawRectAtBottomOfScreen];
    
    
    //GRADIENTS
//    CGContextRef currentContext = UIGraphicsGetCurrentContext();
//    
//    CGContextSaveGState(currentContext);
//    
//    CGColorSpaceRef colorSpace =
//    CGColorSpaceCreateDeviceRGB();
//    
//    UIColor *startColor = [UIColor orangeColor];
//    
//    CGFloat *startColorComponents =
//    (CGFloat *)CGColorGetComponents([startColor CGColor]);
//    UIColor *endColor = [UIColor blueColor];
//    CGFloat *endColorComponents =
//    (CGFloat *)CGColorGetComponents([endColor CGColor]);
//    CGFloat colorComponents[8] = {
//        /* Four components of the orange color (RGBA) */
//        startColorComponents[0],
//        startColorComponents[1],
//        startColorComponents[2],
//        startColorComponents[3], /* First color = orange */
//        /* Four components of the blue color (RGBA) */
//        endColorComponents[0],
//        endColorComponents[1],
//        endColorComponents[2],
//        endColorComponents[3], /* Second color = blue */
//    };
//    CGFloat colorIndices[2] = {
//        0.0f, /* Color 0 in the colorComponents array */ 1.0f, /* Color 1 in the colorComponents array */
//    };
//    CGGradientRef gradient = CGGradientCreateWithColorComponents
//    (colorSpace,
//     (const CGFloat *)&colorComponents, (const CGFloat *)&colorIndices, 2);
//    CGColorSpaceRelease(colorSpace);
//    CGPoint startPoint, endPoint;
//    startPoint = CGPointMake(120,
//                             260);
//    endPoint = CGPointMake(200.0f,
//                           220);
//    CGContextDrawLinearGradient (currentContext,
//                                 gradient,
//                                 startPoint,
//                                 endPoint,
//                                 kCGGradientDrawsBeforeStartLocation |
//                                 kCGGradientDrawsAfterEndLocation);
//    
//    CGGradientRelease(gradient);
//    CGContextRestoreGState(currentContext);
    
    
    //TRANSFORMATIONS
    /* Create the path first. Just the path handle. */
    CGMutablePathRef path = CGPathCreateMutable();
    /* Here are our rectangle boundaries */
    CGRect rectangle = CGRectMake(10.0f,
                                  30.0f,
                                  200.0f,
                                  300.0f);
    /* We want to displace the rectangle to the right by
     100 points but want to keep the y position
     untouched */
//    CGAffineTransform transform = CGAffineTransformMakeTranslation(100.0f,
//                                                                   0.0f);
    
    /* Scale the rectangle to half its size */
//    CGAffineTransform transform =
//    CGAffineTransformMakeScale(0.5f, 0.5f);
    
    /* Rotate the rectangle 45 degrees clockwise */
    CGAffineTransform transform =
    CGAffineTransformMakeRotation((45.0f * M_PI) / 180.0f);


    /* Add the rectangle to the path */
    CGPathAddRect(path,
                  &transform,
                  rectangle);
    /* Get the handle to the current context */
    CGContextRef currentContext =
    UIGraphicsGetCurrentContext();
    /* Add the path to the context */
    CGContextAddPath(currentContext,
                     path);
    /* Set the fill color to cornflower blue */
    [[UIColor colorWithRed:0.20f
                     green:0.60f
                      blue:0.80f
                     alpha:1.0f] setFill]; /* Set the stroke color to brown */
    [[UIColor brownColor] setStroke];
    /* Set the line width (for the stroke) to 5 */
    CGContextSetLineWidth(currentContext,
                          5.0f);
    /* Stroke and fill the path on the context */
    CGContextDrawPath(currentContext,
                      kCGPathFillStroke);
    /* Dispose of the path */
    CGPathRelease(path);
    
}

- (void) drawRectAtTopOfScreen{
    /* Get the handle to the current context */
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //SAVING THE CONTEXT BEFORE APPLYING SHADOW
    CGContextSaveGState(currentContext);
    
    CGContextSetShadowWithColor(currentContext,
                                CGSizeMake(10.0f, 10.0f),
                                20.0f,
                                [[UIColor grayColor] CGColor]);
    /* Create the path first. Just the path handle. */
    CGMutablePathRef path = CGPathCreateMutable();
    /* Here are our rectangle boundaries */
    CGRect firstRect = CGRectMake(55.0f,
                                  60.0f,
                                  150.0f,
                                  150.0f);
    /* Add the rectangle to the path */
    CGPathAddRect(path,
                  NULL,
                  firstRect);
    /* Add the path to the context */
    CGContextAddPath(currentContext,
                     path);
    /* Set the fill color to cornflower blue */
    [[UIColor colorWithRed:0.20f
                     green:0.60f
                      blue:0.80f
                     alpha:1.0f] setFill];
    /* Fill the path on the context */
    CGContextDrawPath(currentContext,
                      kCGPathFill);
    /* Dispose of the path */
    CGPathRelease(path);
    
    /* Restore the context to how it was
     when we started */
    CGContextRestoreGState(currentContext);
}

- (void) drawRectAtBottomOfScreen{
    /* Get the handle to the current context */
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGMutablePathRef secondPath = CGPathCreateMutable();
    CGRect secondRect = CGRectMake(150.0f,
                                   250.0f,
                                   100.0f,
                                   100.0f);
    CGPathAddRect(secondPath,
                  NULL,
                  secondRect);
    CGContextAddPath(currentContext,
                     secondPath);
    [[UIColor purpleColor] setFill];
    CGContextDrawPath(currentContext,
                      kCGPathFill);
    CGPathRelease(secondPath);
}

- (void) drawRooftopAtTopPointof:(CGPoint)paramTopPoint textToDisplay:(NSString *)paramText
                        lineJoin:(CGLineJoin)paramLineJoin
{
    /* Set the color that we want to use to draw the line */

    [[UIColor brownColor] set];
    /* Get the current graphics context */
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    /* Set the line join */
    CGContextSetLineJoin(currentContext,
                         paramLineJoin);
    /* Set the width for the lines */
    CGContextSetLineWidth(currentContext,
                          20.0f);
    /* Start the line at this point */
    CGContextMoveToPoint(currentContext,
                         paramTopPoint.x - 140,
                         paramTopPoint.y + 100);
    /* And end it at this point */
    CGContextAddLineToPoint(currentContext,
                            paramTopPoint.x,
                            paramTopPoint.y);
    /* Extend the line to another point to
     make the rooftop */
    CGContextAddLineToPoint(currentContext,
                            paramTopPoint.x + 140,
                            paramTopPoint.y + 100);
    /* Use the context's current color to draw the lines */
    CGContextStrokePath(currentContext);
    /* Draw the text in the rooftop using a black color */
    [[UIColor blackColor] set];
    /* Now draw the text */
    CGPoint drawingPoint = CGPointMake(paramTopPoint.x - 40.0f,
                                       paramTopPoint.y + 60.0f);
    UIFont *font = [UIFont boldSystemFontOfSize:30.0f];
    [paramText drawAtPoint:drawingPoint
            withAttributes:@{NSFontAttributeName : font}];
}


@end
