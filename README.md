Twecoll is a Twitter command-line tool written in Python. It can be used to retrieve data from Twitter and purge favorites, its only data-altering feature. It is based on a sub-command principle meaning calls to twecoll are generally followed by a keyword which instruct twecoll what to do. Below is a list of examples followed by a brief explanation of each command. Running twecoll requires Python 2.7 and the argparse library. The igraph library is optional. It was not tested with Python 3 and currently breaks with Python 2.6.

Place twecoll in your path and create a working directory to store the data collected. Twecoll creates a number of files and folders to store its data.

* fdat: directory containing friends of friends files as well as membership data
* img: directory containing avatar images of friends
* .dat: extension of account details data (friends, followers, avatar URL, etc. for account friends)
* .twt: extension of tweets file (timestamp, tweet)
* .fav: extension of favorites file (id, timestamp, user id, screen name, tweet)
* .gml: extension of edgelist file (nodes and edges)
* .png: edgelist graph image (igraph must be installed)
* .m: membership data file (fdat)
* .f: friends data (fdat)

Twecoll uses oauth and has been updated to support the 1.1 version of the Twitter REST API. Register your own copy of twecoll on http://dev.twitter.com and copy the consumer key and secret to .twecoll. Place that file in your home directory. The first time you run a twecoll command, it will retrieve the oauth token and secret. Follow the instructions on the console. Twecoll has built-in help, version and API status switches invoked with -h, -v and -s respectively. Each command can also be invoked with the help switch for additional information about its sub-options.


## Downloading Favorites
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


## Downloading Tweets
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


## Generating a Twitter Graph
It is possible to generate a gml file of your first and second degree relationships on Twitter. This is a multi-step process that takes time due to API throttling by Twitter. In order to generate the graph, twecoll retrieves the handle's friends and all friends-of-friends (2nd degree relationships). It then calculates the relations between those, ignoring 2nd degree relationships to which the handle is not connected. In other words, it looks only for relationships among the friends of the handle supplied to it.

First retrieve the handle details

```
$ twecoll init jdevoo
```

This generates a jdevoo.dat file. It also populates an img directory with avatar images. Now, retrieve friends of each entry in the .dat file.

```
$ twecoll fetch jdevoo
```

This populates the fdat directory. You can now generate the graph file.

```
$ twecoll edgelist jdevoo
```

This generates a jdevoo.gml file in Graph Model Language. If you have installed the python version of igraph, a .png file will also be generated with a visualization of the gml data. You can also use other packages to visualize your gml file, e.g. Gephi.


## Back-of-envelope Metrics
Valdis Krebs of OrgNet originally posted about simple metrics to estimate the influence of a Twitter user. Twecoll can calculate these indicators provided it has the membership information for each entry in the .dat file. Memberships represent the number of times someone has been listed on Twitter. Two steps are required:

First retrieve membership data which generates .m files located under the fdat directory.

```
$ twecoll memberships jdevoo
```

Then generate the data containing the BoE metrics:

```
$ twecoll metrics jdevoo
```

This produces a jdevoo.boe file


## Usage
```
$ twecoll -h
usage: twecoll [-h] [-v] [-s]
               {init,fetch,memberships,metrics,tweets,favorites,edgelist} ...
               screen_name

Twitter Collection Tool

positional arguments:
  screen_name           Twitter screen name

optional arguments:
  -h, --help            show this help message and exit
  -v, --version         show program's version number and exit
  -s, --stats           show Twitter API stats and exit

sub-commands:
  {init,fetch,memberships,metrics,tweets,favorites,edgelist}
    init                retrieve friends data for screen_name
    fetch               retrieve friends of handles in .dat file
    memberships         retrieve memberships
    metrics             generate back-of-envelope metrics
    tweets              retrieve tweets
    favorites           retrieve favorites
    edgelist            generate graph in GML format
```

## Changes

* Version 1.1
	- Initial commit
* Version 1.2
	- Added option to init to retrieve followers instead of friends

