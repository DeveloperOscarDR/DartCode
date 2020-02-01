import 'dart:async';
import 'package:http/http.dart' as http;

class SoapClient {

	String _url; // Url sin el WSDL
	String _action;
	String _body;

	SoapClient(String url){
		_url = url;
	}

	void setSOAPAction(String action){
		_action = action;
	}

	void setBody(String body){
		_body = body;
	}

	getResponse() async {

		var response = await http.post(_url,
			body: _body,
			headers: {
				"Content-Type"	: "text/xml;charset=UTF-8",
				"SOAPAction"	: _action
			}
		);

		return response;
	}
}