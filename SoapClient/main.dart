import './SoapClient.dart';
import 'package:xml2json/xml2json.dart';
import 'dart:convert';

void main() async {
	final SoapClient soap = new SoapClient('https://www.crcind.com:443/csp/samples/SOAP.Demo.cls');
	final Xml2Json myTransformer = Xml2Json();

	soap.setSOAPAction('http://tempuri.org/SOAP.Demo.FindPerson');
	soap.setBody('''
	<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org">
	   <soapenv:Header/>
	   <soapenv:Body>
	      <tem:FindPerson>
	         <!--Optional:-->
	         <tem:id>110</tem:id>
	      </tem:FindPerson>
	   </soapenv:Body>
	</soapenv:Envelope>
	''');

	var response = await soap.getResponse();

	// Si el statusCode es 200, el web service respondio correctamente.
	if(response.statusCode == 200){

		try {
			// Transformo el XML en JSON
			myTransformer.parse(response.body);
			var json = myTransformer.toGData();
			
			// Transormo el JSON en Objeto
			var response_obj = jsonDecode(json);

			// Obtengo el atributo FindPersonResult del objeto de respuesta
			var FindPersonResult = response_obj['SOAP-ENV\$Envelope']['SOAP-ENV\$Body']['FindPersonResponse']['FindPersonResult'];

			// Muestro en pantalla todos los sub atributos de FindPersonResult
			if(FindPersonResult != null){
				print("Name: " + FindPersonResult['Name']['\$t'].toString());
				print("SSN: "  + FindPersonResult['SSN']['\$t'].toString());
				print("DOB: "  + FindPersonResult['DOB']['\$t'].toString());
			}else{
				print("No se encontro la persona.");
			}

		}catch(e){
			print("Exception: " + e.toString());
		}

	// Si el statusCode es distinto a 200, muestro el codigo de error
	}else{
		print("ERROR " + response.statusCode.toString() + ": " + response.body);
	}
}