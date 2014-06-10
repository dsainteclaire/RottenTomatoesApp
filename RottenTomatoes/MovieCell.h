//
//  MovieCell.h
//  RottenTomatoes
//
//  Created by David Sainte-Claire on 6/8/14.
//  Copyright (c) 2014 David Sainte-Claire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *movieSynopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;

@end
