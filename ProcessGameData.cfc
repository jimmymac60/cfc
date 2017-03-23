component  accessors = true  extends = "BaseDataProcessor" {
	property string 	dsn ;
	property date 		gameDate ;
	property string 	urlStr ;
	property string 	fileDirectory;



	public  function init( string dsn) {

		setDsn(arguments.dsn);

		return this ;

	}



	// function required row with yearid , monthid, dayid ; change to database script if necessary
	private string function getRemoteUrlString(type, row){
		var paramStruct = {};
		switch(type) {
		    case "master":
		    	  paramStruct["url"] =  "http://local.website/games/" & row.yearid & "_" & row.monthid & "_" & row.dayid & "/score.xml" ;
		        paramStruct["directory"] = "C:\scores\";
		        paramStruct["filename"] = row.gameid & ".xml" ;

		        break;

 		    case "player":
		    	  paramStruct["url"] =  "http://local.website/players/" & row.yearid & "_" & row.monthid & "_" & row.dayid & "/player.json" ;
		        paramStruct["directory"] = "C:\players\";
		        paramStruct["filename"] = row.playerID & ".json" ;

		        break;
		}
		return paramStruct;
	}

    // Queries  that returns all of the games for the date given
	private  Query function getGamesByDate()  {

		storedproc procedure="getDailyGameData" datasource = getDsn(){
			procparam value= getGameDate();
			procresult resultset=1 name='getGameData';
	 	}


        return getGameData ;


	}


	private  Query function getStandingsByDate()  {

		storedproc procedure="getStandings" datasource = getDsn(){
			procparam value= getGameDate();
			procresult resultset=1 name='getGameData';
	 	}


        return getGameData ;


	}
	public Query function getStandings(required date gameDate) {

		setGameDate(arguments.gameDate);
		return getStandingsByDate();

	}




	private  Query function getPlayerData() {

		storedproc procedure="getPlayers" {

			procresult resultset=1 name='players';
	 	}
        return players ;
	}


	/* End Query Section */

	public Query function getQryGameData(required date gameDate) {

		setGameDate(arguments.gameDate);
		return getGamesByDate();

	}



	/*
		The following section is for downloading specific urls. The code is the same
		for all except the database function call and the url. Each function here will
		make an http call and write the xml or json to disk. A separate process will
		then read in the file and parse it and load the data into the database. Each
		query returns data with a year, month and day value.

		(Although there is a date
		field integers are added as columns to speed up grouping data by year or month
		and so 	on. )

	*/
	public void function downloadScoreBoardURLs() {
		local.qry = getGamesByDate();
		var paramsStruct =  getRemoteUrlString("master", row );

		var urlStr = "";
		var httpContent = "";
		for (row in local.qry){

			urlStr 		=	getRemoteUrlString("master", row );
			httpContent = 	getUrlData(paramsStruct["url"]);

			super.WriteFileToDisk(paramsStruct["directory"], paramsStruct["filename"] ,  httpContent  );

		}

	}


	public void function downloadPlayerData() {
		local.qry 		= getPlayerData();
		var paramsStruct 	=  getRemoteUrlString("player", row );

		var urlStr = "";
		var httpContent = "";
		for (row in local.qry){

			urlStr 		= super.getRemoteUrlString("player", row );
			httpContent = getUrlData(paramsStruct["url"]);

			super.WriteFileToDisk(paramsStruct["directory"], paramsStruct["filename"] ,  httpContent  );

		}

	}



}
