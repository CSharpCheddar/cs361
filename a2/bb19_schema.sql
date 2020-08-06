CREATE TABLE Players19 (
  playerID VARCHAR(10), --A unique code assigned to each player. The playerID links
                        --the data in this file with records in the other files.
  name_first VARCHAR(50), --First name
  name_last VARCHAR(50), --Last name
  bats CHAR(1), --Player’s batting hand (left, right, or both)
  throws CHAR(1), --Player’s throwing hand (left or right)
  CONSTRAINT PRIMARY KEY (playerID)
);

CREATE TABLE Teams19 (
  teamID CHAR(3), --Three-letter team code
  lgID CHAR(2), --Two-letter league code
  divID CHAR(1), --One letter code for the division the team player in
  rank SMALLINT, --Position in final standings in that division
  G SMALLINT, --Games played
  W SMALLINT, --Games won
  L SMALLINT, --Games lost
  div_winner CHAR(1), --Division winner (Y or N)
  wc_winner CHAR(1), --Wild card winner (Y or N)
  lg_winner CHAR(1), --League champion (Y or N)
  ws_winner CHAR(1), --World series winner
  team_name VARCHAR(50), --Team’s full name
  park VARCHAR(255), --Name of team’s home ballpark
  CONSTRAINT PRIMARY KEY (teamID)
);

CREATE TABLE Batting19 (
  playerID VARCHAR(10), --Player ID code
  yearID SMALLINT, --Will always be 2019 in data for this assignment
  stint SMALLINT, --Used to identify a particular continuous period that a player
                  --played for one team during the season. For example, a player
                  --who played during May for the Brewers, was then sent down to the
                  --minors and came back to play again for the Brewers in August would
                  --have two stints -- numbered 1 and 2
  teamID CHAR(3), --Three-letter team ID
  lgID CHAR(2), --Two letter league ID -- NL or AL
  G SMALLINT, --Number of games appeared in during this stint
  AB SMALLINT, --Number of at bats
  R SMALLINT, --Number of runs
  H SMALLINT, --Number of hits
  2B SMALLINT, --Number of doubles
  3B SMALLINT, --Number of triples
  HR SMALLINT, --Number of home runs
  RBI SMALLINT, --Number of runs batted in
  SB SMALLINT, --Number of stolen bases
  CS SMALLINT, --Number of times caught trying to steal a base
  BB SMALLINT, --Number of base on balls (walks)
  SO SMALLINT, --Number of time player struck out
  IBB SMALLINT, --Number of intentional walks received
  HBP SMALLINT, --Number of time hit by pitch
  SF SMALLINT, --Number of sacrifice flied
  GIDP SMALLINT, --Number of times grounded into double play
  CONSTRAINT PRIMARY KEY (playerID, stint),
  CONSTRAINT FOREIGN KEY (playerID) REFERENCES Players19 (playerID),
  CONSTRAINT FOREIGN KEY (teamID) REFERENCES Teams19 (teamID)
);

CREATE TABLE Pitching19 (
  playerID VARCHAR(10), --Player ID code
  yearID SMALLINT, --Will always be 2019 for this assignment
  stint SMALLINT, --See description in Batting table
  teamID CHAR(3), --Three-letter team code
  lgID CHAR(2), --Two-letter league code
  W SMALLINT, --Number of games won
  L SMALLINT, --Number of games lost
  G SMALLINT, --Number of total games pitched in
  GS SMALLINT, --Number of games started
  CG SMALLINT, --Number of complete games
  SHO SMALLINT, --Number of shutouts pitched
  SV SMALLINT, --Number of saves as a relief pitcher
  IPouts INT, --Outs Pitched (which innings pitched x 3)
  H SMALLINT, --Number of hits allowed
  ER SMALLINT, --Number of earned runs
  HR SMALLINT, --Number of home runs allowed
  BB SMALLINT, --Number of base on balls allowed
  SO SMALLINT, --Number of strike outs
  ERA REAL, --Earned run average
  IBB SMALLINT, --Number of intentional walks
  WP SMALLINT, --Number of wild pitches
  HBP SMALLINT, --Number of batters hit by pitch
  BK SMALLINT, --Number of balks
  BFP SMALLINT, --Total number of batters faced by this pitcher during this stint
  GF SMALLINT, --Number of games finished
  R SMALLINT, --Number of runs allowed
  CONSTRAINT PRIMARY KEY (playerID, stint),
  CONSTRAINT FOREIGN KEY (playerID) REFERENCES Players19 (playerID),
  CONSTRAINT FOREIGN KEY (teamID) REFERENCES Teams19 (teamID)
);

CREATE TABLE Fielding19 (
  playerID VARCHAR(10), --Player ID code
  yearID SMALLINT, --Will always be 2019 for this assignment
  stint SMALLINT, --See description in batting table
  teamID CHAR(3), --Three-letter team ID
  lgID CHAR(2), --Two-letter league code
  POS CHAR(2), --Two-letter code for the position
  G SMALLINT, --Games appeared in
  GS SMALLINT, --Games started
  InnOuts INT, --Number of innings in terms of outs (actual innings in the usual
  --sense is this number times 3)
  PO SMALLINT, --Number of out-outs made
  A SMALLINT, --Number of assists
  E SMALLINT, --Number of errors
  DP SMALLINT, --Number of double plays
  PB SMALLINT, --Number of passed balls (for catchers)
  WP SMALLINT, --Number of wild pitches (for catchers)
  SB SMALLINT, --Number of stolen bases against (for catchers)
  CS SMALLINT, --Number of runners caught stealing (for catchers)
  CONSTRAINT PRIMARY KEY (playerID, stint, teamID, POS),
  CONSTRAINT FOREIGN KEY (playerID) REFERENCES Players19 (playerID),
  CONSTRAINT FOREIGN KEY (teamID) REFERENCES Teams19 (teamID)
);

CREATE TABLE Appearances19 (
  yearID SMALLINT, --Will always be 2019 for this assignment
  teamID CHAR(3), --Three-letter team code
  lgID CHAR(2), --Two-letter league code
  playerID VARCHAR(10), --Player ID code
  G_all SMALLINT, --Total games appeared in
  GS SMALLINT, --Games started
  G_batting SMALLINT, --Number of games in which this player batted
  G_defense SMALLINT, --Number of games in which this player played defense in the field
  G_p SMALLINT, --Number of games appeared in as a pitcher
  G_c SMALLINT, --Number of games appeared in as a catcher
  G_1b SMALLINT, --Number of games appeared in as a first baseman
  G_2b SMALLINT, --Number of games appeared in as a second baseman
  G_3b SMALLINT, --Number of games appeared in as a third baseman
  G_ss SMALLINT, --Number of games appeared in as a shortstop
  G_lf SMALLINT, --Number of games appeared in as a left fielder
  G_cf SMALLINT, --Number of games appeared in as a center fielder
  G_rf SMALLINT, --Number of games appeared in as a right fielder
  G_dh SMALLINT, --Number of games appeared in as a designated hitter
  G_ph SMALLINT, --Number of games appeared in as a pinch hitter
  G_pr SMALLINT, --Number of games appeared in as a pinch runner
  PRIMARY KEY (playerID, teamID),
  CONSTRAINT FOREIGN KEY (playerID) REFERENCES Players19 (playerID),
  CONSTRAINT FOREIGN KEY (teamID) REFERENCES Teams19 (teamID)
);
