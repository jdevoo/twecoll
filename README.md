Twecoll is a Twitter command-line tool written in Python. It can be used to retrieve data from Twitter and purge favorites (its only data-altering feature). It is based on a sub-command principle meaning calls to twecoll are based on a keyword which instructs twecoll what to do. Below is a list of examples followed by a brief explanation of each command. Running twecoll requires Python 2.7 and the argparse library. It was tested with igraph 0.6 and 0.7.1. The igraph library is optional and is used to generate a clustered graph of the network. It was not tested with Python 3.


## Installation

Place twecoll in your path and create a working directory to store the data collected. Twecoll creates a number of files and folders to store its data.

* fdat: directory containing friends of friends files
* img: directory containing avatar images of friends
* .dat: extension of account details data (friends, followers, avatar URL, etc. for account friends)
* .twt: extension of tweets file (timestamp, tweet)
* .fav: extension of favorites file (id, timestamp, user id, screen name, tweet)
* .gml: extension of edgelist file (nodes and edges)
* .f: friends data (fdat)

Twecoll uses oauth and has been updated to support the 1.1 version of the Twitter REST API. Register your own copy of twecoll on http://dev.twitter.com and copy the consumer key and secret.

The first time you run a twecoll command, it will ask you for the key and secret. Then it will retrieve the oauth token. Follow the instructions on the console.

## Examples

#### Download and Purge Favorites
Historically, this was twecoll's main use: download all favorited tweets in a file for search purposes. Let's take the handle 'jdevoo' as an example.

```
$ twecoll favorites jdevoo
```

This will produce a jdevoo.fav file containing all favorites including a tweet ID, timestamp, user ID, handle, text (urf-8).
In order to purge the favorites, twecoll needs the .fav file. You can the execute:

```
$ twecoll favorites -p jdevoo
```

This is the only command that alters account data. You will need to select the Read+Write permission model for this to work when registering twecoll.

#### Downloading Tweets
Twecoll can download up to 3000 tweets for a handle or run search queries.

```
$ twecoll tweets jdevoo
```

This would generate a jdevoo.twt file containing all tweets including timestamp and text (utf-8).
In order search for tweets related to a certain hashtag or run a more advanced query, use the -q switch and double-quotes around the query string:

```
$ twecoll tweets -q "#dg2g"
```

This will also generate a .twt file name with the url-encoded search string.

#### Generating a Graph
It is possible to generate a GML file of your first and second degree relationships on Twitter. This is a two-step process that takes time due to API throttling by Twitter. In order to generate the graph, twecoll retrieves the handle's friends (or followers) and all friends-of-friends (2nd degree relationships). It then calculates the relations between those, ignoring 2nd degree relationships to which the handle is not connected. In other words, it looks only for friend relationships among the friends/followers of the handle or query tweets initially supplied.

First retrieve the handle details

```
$ twecoll init jdevoo
```

This generates a jdevoo.dat file. It also populates an img directory with avatar images. It is also possible to initialize from a .twt file using the -q option. In this example, retrieve friends of each entry in the .dat file.

```
$ twecoll fetch jdevoo
```

This populates the fdat directory. You can now generate the graph file using the defaults.

```
$ twecoll edgelist jdevoo
```

This generates a jdevoo.gml file in Graph Model Language. If you have installed the python version of igraph, a .png file will also be generated with a visualization of the GML data. You can also use other packages to visualize your GML file, e.g. Gephi.
The GML file will include friends, followers, memberships, ranks and statuses counts as properties. If followers count is not equal to zero, the friends-to-followers and listed-to-followers ratios will be calculated.

## Usage

Twecoll has built-in help, version and API status switches invoked with -h, -v and -s respectively. Each command can also be invoked with the help switch for additional information about its sub-options.

```
$ twecoll -h
usage: twecoll [-h] [-v] [-s]
               {resolve,init,fetch,tweets,favorites,edgelist} ...

Twitter Collection Tool

optional arguments:
  -h, --help            show this help message and exit
  -v, --version         show program's version number and exit
  -s, --stats           show Twitter throttling stats and exit

sub-commands:
  {resolve,init,fetch,tweets,favorites,edgelist}
    resolve             retrieve user_id for screen_name or vice versa
    init                retrieve friends data for screen_name
    fetch               retrieve friends of handles in .dat file
    tweets              retrieve tweets
    favorites           retrieve favorites
    edgelist            generate graph in GML format
```

## Changes

* Version 1.1
	- Initial commit
* Version 1.2
	- Added option to init to retrieve followers instead of friends
* Version 1.3
 	- simplified metrics now included in GML file
* Version 1.4
	- Simplified membership retrieval and improved graphs
* Version 1.5
	- Changes to community finding and visualization
* Version 1.6
	- Added support for multiple arguments in edgelist
* Version 1.7
	- Added ability to add list members to dat file
* Version 1.8
	- Fetch tweets from list for a given user
