/*
	This base component will provide all methods common to processing data downloaded
	on XML, JSON or CSV content. This will allow us to reuse the same function such as
	writing the file to disk or serializing /deserializing data.

	This will allow us to replace CF functions with .NET or Java classes if useful and
	all sub-classed components will benefit. We could also add for example some validation
	for the http calls that me be valid only when a record exists in a table of valid URLS.
    
    Most components should extend this one. 

*/


component {

	private function init(){
		/*

			Just a placeholder for the moment . May add a security check
			or environmental variables later.

		*/
		return this;
	}

	private String function getUrlData(required string urlStr){


 		http method="GET" url="#arguments.urlStr#" result="urlData";

 		return urlData.filecontent;

	}

	private Array function parseXmlString(required xml str ) {

			return XmlParse(str);

	}


	private Array function parseJsonString(required json str ) {

			return DeserializeJson(str);

	}

	private void function WriteFileToDisk( String dir, String filename, String content ) {


		fileWrite(dir & "\" & filename , content );


	}

}
