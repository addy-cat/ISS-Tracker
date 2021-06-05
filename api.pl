#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;
use JSON qw( decode_json );

#Generalize information from an API
sub api_config {

  my $api_content = $_[0];
  my $search_term = $_[1];
  my $offset = $_[2];
  
  my $index = index($api_content, $search_term);
  $index = $index + $offset;

  my $ret = "";
  for (my $i = $index; $i < $index + $offset; $i++) {
    $ret = $ret.substr($api_content, $i, 1); 
  }

  return $ret; 

}


#Put in data for the ISS API
my $api_content;
my $api = 'https://api.wheretheiss.at/v1/satellites/25544';
$api_content = get($api);
die "Can't access the API right now. Is it down?" unless defined $api_content;

my $lat = api_config($api_content, 'latitude', 10);
my $lon = api_config($api_content, 'longitude', 11);

print "\nThe ISS is at this longitude and latitude:\n";
print "Latitude: ", $lat."\n", "Longitude: ", $lon."\n\n";




#Calculate how far user is from the ISS
print "Lets calculate how far you are away from the ISS.\n";
print "Enter your latitude: \n";
my $entered_lat = <>;
chomp($entered_lat);
print "Your latitude is: ", $entered_lat, "\n";
print "Now enter your longitude: \n";
my $entered_lon = <>;
chomp($entered_lon);
print "Your longitude is: ", $entered_lon, "\n";

print "Calculating...\n";

my $pi_div_180 = 0.01745329251;
my $calculation = 0.5 - cos((($entered_lat - $lat) * $pi_div_180))/2 + 
                  cos(($lat * $pi_div_180)) * cos(($entered_lat)) * 
                  (1 - cos((($entered_lon - $lon) * $pi_div_180)))/2;
my $distance = 12742 * sqrt($calculation);
print "You are ", $distance, " kilometers away from the ISS.\n";






