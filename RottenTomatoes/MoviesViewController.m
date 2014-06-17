//
//  MoviesViewController.m
//  RottenTomatoes
//
//  Created by David Sainte-Claire on 6/8/14.
//  Copyright (c) 2014 David Sainte-Claire. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "AFHTTPRequestOperation.h"
#import "MBProgressHUD.h"
#import "MovieDetailViewController.h"

@interface MoviesViewController ()
@property (strong, nonatomic) IBOutlet UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;
@property (nonatomic, strong) NSArray *moviesArray;

@end

@implementation MoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Movies";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Pull to refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.moviesTableView addSubview:self.refreshControl];
    
    self.moviesTableView.delegate = self;
    self.moviesTableView.dataSource = self;

    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ([data length] > 0 && error == nil) {
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.moviesArray = object[@"movies"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.moviesTableView reloadData];
        } else {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
            headerView.backgroundColor = [UIColor darkGrayColor];
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
            [headerLabel setText:@"Networking Error!"];
            [headerView addSubview:headerLabel];
            self.moviesTableView.tableHeaderView = headerView;
        }
    }];
    
    [self.moviesTableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    self.moviesTableView.rowHeight = 120;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  - TableView methods
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.moviesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.moviesArray[indexPath.row];
    
    cell.movieTitleLabel.text = movie[@"title"];
    cell.movieSynopsisLabel.text = movie[@"synopsis"];
    
    NSDictionary *posters = self.moviesArray[indexPath.row][@"posters"];
    
    NSString *url = posters[@"thumbnail"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        cell.posterImage.image = responseObject;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"TableView clicked at index: %i", indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
     MovieDetailViewController *detailController = [[MovieDetailViewController alloc] init];
    NSDictionary *posters = self.moviesArray[indexPath.row][@"posters"];
    NSDictionary *movie = self.moviesArray[indexPath.row];
    
    detailController.posterDetailUrl = posters[@"original"];
    detailController.movieSynopsis = movie[@"synopsis"];
    detailController.movieTitle = movie[@"title"];

    [[self navigationController] pushViewController:detailController animated:YES];
}

- (void)refresh
{
    NSLog(@"Start of pull to refresh");
    self.moviesTableView.tableHeaderView = nil;
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ([data length] > 0 && error == nil) {
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.moviesArray = object[@"movies"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.moviesTableView reloadData];
        } else {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
            headerView.backgroundColor = [UIColor darkGrayColor];
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
            [headerLabel setText:@"Networking Error!"];
            [headerView addSubview:headerLabel];
            self.moviesTableView.tableHeaderView = headerView;
        }
    }];
    [self.refreshControl endRefreshing];
}

@end
