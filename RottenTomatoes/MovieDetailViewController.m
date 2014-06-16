//
//  MovieDetailViewController.m
//  RottenTomatoes
//
//  Created by David Sainte-Claire on 6/9/14.
//  Copyright (c) 2014 David Sainte-Claire. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "AFHTTPRequestOperation.h"

@interface MovieDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *moviePosterImageView;

@end

@implementation MovieDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.movieTitle;
    self.synopsisLabel.text = self.movieSynopsis;
    self.titleLabel.text = self.movieTitle;
    self.moviePosterImageView.alpha = 0;
    self.contentScrollView.contentSize = CGSizeMake(700, 600);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.posterDetailUrl]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.moviePosterImageView.image = responseObject;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
    [self fadeInImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fadeInImage
{
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:1.0];
    self.moviePosterImageView.alpha = 1.0;
    [UIView commitAnimations];
    
}

@end
