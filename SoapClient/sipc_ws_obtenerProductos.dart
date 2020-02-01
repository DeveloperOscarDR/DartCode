import './SoapClient.dart';
import 'package:xml2json/xml2json.dart';
import 'dart:convert';

void main() async {
	final SoapClient soap = new SoapClient('http://www.precios.uy/sipcWs/DeclaracionDiaria');
	final Xml2Json myTransformer = Xml2Json();

	soap.setSOAPAction('');
	soap.setBody('''
	<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:int="http://interfaces.ws.sipc.bullseye.com.uy/">
	   <soapenv:Header/>
	   <soapenv:Body>
	      <int:obtenerProductos/>
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

			// Obtengo el atributo obtenerProductosResponse del objeto de respuesta
			var ProductosResponse = response_obj['soap\$Envelope']['soap\$Body']['ns2\$obtenerProductosResponse']['return'];

			// Recorro TODOS los articulos y lo muestro en pantalla
			if(ProductosResponse != null){
				for(int i=0; i<ProductosResponse.length; i++){
					print("Cod: " + ProductosResponse[i]['codigo_barra']['\$t'].toString());
					print("Articulo: " + ProductosResponse[i]['nombre']['\$t'].toString());
					print("-------------------------------------------------------------------");
				}
			}else{
				print("No se encontraron articulos.");
			}

		}catch(e){
			print("Exception: " + e.toString());
		}

	// Si el statusCode es distinto a 200, muestro el codigo de error
	}else{
		print("ERROR " + response.statusCode.toString() + ": " + response.body);
	}
}